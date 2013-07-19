/* volume.vapi generated by valac 0.16.1, do not modify. */

[CCode (cheader_filename = "plugins/volume/volume.h")]
public class Core : Peas.ExtensionBase, Jalak.Plugin {
	public Core ();
}
[CCode (cheader_filename = "plugins/volume/pulse_glue.h")]
public class PulseGlue : GLib.Object {
	public PulseGlue (Jalak.Plugin p);
	public void card_info_cb (PulseAudio.Context c, PulseAudio.CardInfo? info, int eol);
	public void context_state_cb (PulseAudio.Context ctx);
	public void event_cb (PulseAudio.Context ctx, PulseAudio.Context.SubscriptionEventType type, uint32 idx);
	public bool postponed_sink_reload ();
	public void pulse_glue_sync_volume (uint32 vol);
	public void server_info_cb (PulseAudio.Context ctx, PulseAudio.ServerInfo? info);
	public void sink_info_cb (PulseAudio.Context ctx, PulseAudio.SinkInfo? info, int eol);
	public void start ();
}
[CCode (cheader_filename = "plugins/volume/volume.h")]
[ModuleInit]
public static void peas_register_types (GLib.TypeModule module);