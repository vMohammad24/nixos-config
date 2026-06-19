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
  };
}
