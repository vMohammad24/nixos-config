{lib, ...}: let
  h = import ./helpers.nix {inherit lib;};
in {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      (h.monitor {
        output = "DP-1";
        mode = "2560x1440@240";
        position = "0x0";
        scale = 1;
        vrr = 1;
        bitdepth = 10;
      })
      (h.monitor {
        output = "DP-2";
        mode = "1920x1080@144";
        position = "-1080x0";
        scale = 1;
        transform = 1;
      })
    ];

    workspace_rule = [
      (h.workspaceRule "1" "DP-1")
      (h.workspaceRule "2" "DP-2")
    ];

    # this is required for sunshine to be accurate with its passthrough
    device = [
      (h.monitor {
        name = "pen-passthrough";
        output = "DP-1";
      })
      (h.monitor {
        name = "touch-passthrough-1";
        output = "DP-1";
      })
      (h.monitor {
        name = "touch-passthrough";
        output = "DP-1";
      })
      (h.monitor {
        name = "keyboard-passthrough";
        output = "DP-1";
      })
      (h.monitor {
        name = "mouse-passthrough";
        output = "DP-1";
      })
      (h.monitor {
        name = "mouse-passthrough-(absolute)";
        output = "DP-1";
      })
    ];
  };
}
