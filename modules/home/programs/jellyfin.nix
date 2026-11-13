{config, ...}: {
  services.jellyfin-mpv-shim = {
    enable = true;
    mpvConfig = config.programs.mpv.config;
    settings = {
      allow_transcode_to_h265 = false;
      always_transcode = false;
      auto_play = true;
      fullscreen = true;
      allow_background = false;
      check_updates = false;
      clock_12h = false;
      close_to_tray = true;
      enable_gui = true;
      mpris = true;
      remember_subtitle_track = true;
      remember_audio_track = true;
      remember_filters = true;
      segment_commercial = true;
      segment_intro = "ask";
      segment_outro = "ask";
      segment_preview = "ask";
      segment_recap = "ask";
      skip_intro_on_seek = true;
      video_volume = 100;
      discord_presence = true;
      start_minimized = true;
    };
  };
}
