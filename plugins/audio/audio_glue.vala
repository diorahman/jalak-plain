/*
 * jalak - plugin app poc
 *
 * Adapted from pa-applet (https://github.com/fernandotcl/pa-applet) 
 * https://github.com/fernandotcl/pa-applet/blob/master/src/pulse_glue.c
 * https://github.com/fernandotcl/pa-applet/blob/master/src/pulse_glue.h
 * Copyright (c) 2012 Fernando Tarlá Cardoso Lemos
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

using PulseAudio;

public class AudioGlue : GLib.Object{
  private PulseAudio.GLibMainLoop loop;
  private PulseAudio.Context context;
  private Context.Flags cflags;
  private Operation sink_reload_operation;
  private bool has_postponed_sink_reload; 
  private uint postponed_sink_reload_timeout_id;

  bool subscribed;
  bool have_default_card;
  private uint32 default_card_index;
  private uint32 default_sink_index;
  private uint8 default_sink_num_channels; 

  private Jalak.Plugin plugin;
  private AudioStatus audio_status;

  public AudioGlue(Jalak.Plugin p){
    GLib.Object();
    plugin = p;
    audio_status = new AudioStatus();
  }

  construct{
    this.has_postponed_sink_reload = false;
    this.sink_reload_operation = null;
    this.postponed_sink_reload_timeout_id = -1;
    this.default_card_index = -1;
    this.default_sink_index = -1;
    this.default_sink_num_channels = 0;
    this.subscribed = false;
    this.have_default_card = false;
  }

  public void init(){
    this.loop = new PulseAudio.GLibMainLoop();
  }

  public void destroy(){
    if(this.has_postponed_sink_reload) Source.remove(postponed_sink_reload_timeout_id);
  }

  public bool postponed_sink_reload(){
    if (this.sink_reload_operation != null)
        return true;

    this.context.get_sink_info_by_index(default_sink_index, sink_info_cb);
    has_postponed_sink_reload = false;

    return false;
  }

  private void run_or_postpone_sink_reload(){
    if(this.sink_reload_operation != null){
      if (this.has_postponed_sink_reload){
        Source.remove(postponed_sink_reload_timeout_id);
      }

      this.postponed_sink_reload_timeout_id = Timeout.add(1000, postponed_sink_reload);
      this.has_postponed_sink_reload = true;
    }else{
      postponed_sink_reload();
      return;
    }
  }

  public void event_cb(Context ctx, Context.SubscriptionEventType type, uint32 idx){
    switch (type & Context.SubscriptionEventType.FACILITY_MASK) {
      case Context.SubscriptionEventType.SERVER : 
        this.context.get_server_info(server_info_cb); 
        break;
      case Context.SubscriptionEventType.CARD : {
          if (idx != default_card_index) return;
          this.context.get_card_info_by_index(default_card_index, this.card_info_cb);
        }
        break;
      case Context.SubscriptionEventType.SINK : 
        if (idx == default_sink_index) run_or_postpone_sink_reload();
        break;
      default: break;
    }
  }

  public void card_info_cb(Context c, CardInfo? info, int eol){
    if (eol > 0)
        return;

    if (eol < 0 || info == null) {
        print("Sink info callback failure\n");
        return;
    }

    audio_status.reset_profiles();

    foreach ( CardProfileInfo profile_info in info.profiles) {

      AudioStatusProfile profile = AudioStatusProfile();
      profile.name = profile_info.name;
      profile.description = profile_info.description;
      profile.priority = profile_info.priority;
      profile.active = info.active_profile == &profile_info;
      audio_status.profiles.append(profile);

      // TODO: push data to plugin via serialized audio_status
      print(profile.name + "\n");
    }

    audio_status.sort_profiles();
  }

  public void sink_info_cb(Context ctx, SinkInfo? info, int eol){
    if(eol > 0) return;
    sink_reload_operation = null;
    bool default_card_changed = !this.have_default_card || this.default_card_index != info.card;
    this.default_card_index = info.card;
    this.default_sink_index = info.index;
    this.default_sink_num_channels = info.volume.channels;

    if(!this.subscribed) {
      this.context.set_subscribe_callback(event_cb);
      this.context.subscribe(Context.SubscriptionMask.SERVER | Context.SubscriptionMask.CARD | Context.SubscriptionMask.SINK);
      this.subscribed = true;
    }

    PulseAudio.Volume volume = info.volume.avg();
    if(volume > PulseAudio.Volume.NORM) volume = PulseAudio.Volume.NORM;
    double vol = volume * 100.0 / PulseAudio.Volume.NORM;

    this.audio_status.volume = vol;
    this.audio_status.muted = info.mute > 0 ? true : false;
    
    // TODO: serialize audio_status and send to audio plugin
    plugin.update(vol.to_string());

    if(default_card_changed){
      this.context.get_card_info_by_index(this.default_card_index, this.card_info_cb);
    }

  }

  public void server_info_cb(Context ctx, ServerInfo? info){
    if(sink_reload_operation != null) sink_reload_operation.cancel();
    sink_reload_operation = this.context.get_sink_info_by_name(info.default_sink_name, this.sink_info_cb);
    run_or_postpone_sink_reload(); 
  }

  public void context_state_cb(Context ctx){
    Context.State state = ctx.get_state();
    if (state == Context.State.READY) {
      this.context.get_server_info(this.server_info_cb);
    }
  }

  public bool try_connect(){
    Proplist proplist = new Proplist();
    proplist.sets(Proplist.PROP_APPLICATION_NAME, "Jalak.Audio.Plugin");
    this.context = new PulseAudio.Context(loop.get_api(), null, proplist);

    this.cflags = Context.Flags.NOFAIL;
    this.context.set_state_callback(this.context_state_cb);
    if(this.context.connect( null, this.cflags, null) < 0){
      return false;      
    }
    return true;
  }

  public void start()
  {
      init();
      try_connect();
  }

  public void sync_volume(uint32 vol){
    if(this.context == null) return;
            
    CVolume cvolume = CVolume();
    cvolume.init();
    cvolume.set(default_sink_num_channels, vol * PulseAudio.Volume.NORM / 100);

    this.context.set_sink_volume_by_index(default_sink_index, cvolume);
  }

  public void sync_active_profile(){

    if(this.context == null) return;

    AudioStatusProfile active_profile = AudioStatusProfile();

    foreach(AudioStatusProfile profile in this.audio_status.profiles){
      if(profile.active){
        active_profile = profile;
        break;
      }
    }

    this.context.set_card_profile_by_index(default_card_index, active_profile.name);
  }
} 