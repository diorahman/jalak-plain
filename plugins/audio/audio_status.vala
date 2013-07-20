/*
 * jalak - plugin app poc
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */


const double STATUS_STEP_SIZE = 5.0;

struct AudioStatusProfile{
  string name;
  string description;
  uint32 priority;
  bool active;
}

class AudioStatus : GLib.Object{
  public double volume;
  public bool muted;
  public SList<AudioStatusProfile?> profiles;

  public AudioStatus(){
    volume = 0.0;
    muted = true;
  }

  public void destroy(){
    reset_profiles();
  }

  public void reset_profiles(){
    foreach (AudioStatusProfile? profile in profiles) {
      profiles.remove(profile);
    }
  }

  public void raise_volume()
  {
    volume += STATUS_STEP_SIZE;
    if (volume > 100.0)
        volume = 100.0;
  }

  public void lower_volume()
  {
      volume -= STATUS_STEP_SIZE;
      if (volume < 0.0)
          volume = 0.0;
  }

  public void toggle_muted()
  {
      muted = !muted;
  }

  public void sort_profiles()
  {
      if (profiles != null) profiles.sort((a,b) => {
          if (a.priority > b.priority) return -1;
          else if (b.priority > a.priority) return 1;
          else return 0;
        });
  }

  public string serialize(){
    // TODO: serialized audio_status, including volume, muted and profiles
    return "{}"; // 
  }
}