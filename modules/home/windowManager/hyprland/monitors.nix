{...}: {
  wayland.windowManager.hyprland.settings = {
    monitorv2 = [
      {
        output = "DP-1";
        mode = "2560x1440@240";
        position = "0x0";
        scale = 1;
      }
      {
        output = "DP-2";
        mode = "1920x1080@144";
        position = "-1080x0";
        scale = 1;
        transform = 1;
      }
    ];

    workspace = [
      "1, monitor:DP-1"
      "2, monitor:DP-2"
    ];

    # this is required for sunshine to be accurate with its passthrough
    device = [
      {
        name = "pen-passthrough";
        output = "DP-1";
      }
      {
        name = "touch-passthrough-1";
        output = "DP-1";
      }
      {
        name = "touch-passthrough";
        output = "DP-1";
      }
      {
        name = "keyboard-passthrough";
        output = "DP-1";
      }
      {
        name = "mouse-passthrough";
        output = "DP-1";
      }
      {
        name = "mouse-passthrough-(absolute)";
        output = "DP-1";
      }
    ];
  };
}
