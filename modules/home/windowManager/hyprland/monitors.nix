{...}: {
  wayland.windowManager.hyprland.settings.monitorv2 = [
    {
      output = "DP-2";
      mode = "2560x1440@240";
      position = "0x0";
      scale = 1;
    }
    {
      output = "HDMI-A-1";
      mode = "1920x1080@60";
      position = "-1080x0";
      scale = 1;
      transform = 1;
    }
  ];
}
