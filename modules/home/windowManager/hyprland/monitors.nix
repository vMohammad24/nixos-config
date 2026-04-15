{...}: {
  wayland.windowManager.hyprland.settings = {
    monitorv2 = [
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

    # this is required for sunshine to be accurate with its passthrough
    device = [
      {
        name = "pen-passthrough";
        output = "DP-2";
      }
      {
        name = "touch-passthrough-1";
        output = "DP-2";
      }
      {
        name = "touch-passthrough";
        output = "DP-2";
      }
      {
        name = "keyboard-passthrough";
        output = "DP-2";
      }
      {
        name = "mouse-passthrough";
        output = "DP-2";
      }
      {
        name = "mouse-passthrough-(absolute)";
        output = "DP-2";
      }
    ];
  };
}
