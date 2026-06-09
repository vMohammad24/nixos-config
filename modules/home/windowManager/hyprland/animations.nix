{lib, ...}: let
  h = import ./helpers.nix {inherit lib;};
in {
  wayland.windowManager.hyprland.settings = {
    config.animations.enabled = true;

    curve = [
      (h.curve "smoothOut" [[0.25 0.8] [0.2 1.0]])
      (h.curve "quickInOut" [[0.4 0.0] [0.6 1.0]])
    ];

    animation = [
      (h.anim "global" 4 "smoothOut" {})
      (h.anim "windows" 5 "smoothOut" {style = "popin 80%";})
      (h.anim "windowsIn" 5 "smoothOut" {style = "popin 80%";})
      (h.anim "windowsOut" 3 "quickInOut" {style = "popin 80%";})
      (h.anim "border" 2 "quickInOut" {})
      (h.anim "fadeIn" 3 "smoothOut" {})
      (h.anim "fadeOut" 2 "quickInOut" {})
      (h.anim "fade" 3 "smoothOut" {})
      (h.anim "layers" 4 "smoothOut" {})
      (h.anim "layersIn" 4 "smoothOut" {})
      (h.anim "layersOut" 3 "quickInOut" {})
      (h.anim "workspaces" 4 "smoothOut" {})
      (h.anim "workspacesIn" 4 "smoothOut" {})
      (h.anim "workspacesOut" 4 "smoothOut" {})
      (h.anim "zoomFactor" 5 "smoothOut" {})
      (h.anim "specialWorkspace" 2 "quickInOut" {style = "slidevert";})
    ];
  };
}
