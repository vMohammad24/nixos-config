{lib, ...}: let
  h = import ./helpers.nix {inherit lib;};
in {
  wayland.windowManager.hyprland.settings = {
    config.animations.enabled = true;

    curve = [
      (h.curve "easeOutQuint" [[0.23 1.0] [0.32 1.0]])
      (h.curve "quick" [[0.15 0.0] [0.1 1.0]])
      (h.spring "smooth" 1 520 39)
      (h.spring "resize" 1 700 52)
      (h.spring "soft" 1 160 24)
    ];

    animation = [
      (h.animSpring "global" 3 "smooth" {})

      (h.animSpring "windows" 3 "smooth" {style = "popin 85%";})
      (h.animSpring "windowsIn" 3 "smooth" {style = "popin 85%";})
      (h.animSpring "windowsOut" 2.2 "resize" {style = "popin 90%";})
      (h.animSpring "windowsMove" 3 "resize" {})

      (h.anim "border" 3 "easeOutQuint" {})

      (h.anim "fade" 2.5 "quick" {})
      (h.anim "fadeIn" 2.2 "quick" {})
      (h.anim "fadeOut" 2 "quick" {})
      (h.anim "fadeSwitch" 1.5 "quick" {})
      (h.anim "fadeShadow" 2 "easeOutQuint" {})
      (h.anim "fadeDim" 3 "easeOutQuint" {})
      (h.anim "fadeDpms" 2 "quick" {})

      (h.animSpring "layers" 3 "smooth" {})
      (h.animSpring "layersIn" 3.2 "smooth" {})
      (h.animSpring "layersOut" 2.4 "smooth" {})
      (h.anim "fadeLayers" 2 "quick" {})
      (h.anim "fadeLayersIn" 2 "quick" {})
      (h.anim "fadeLayersOut" 1.8 "quick" {})

      (h.anim "fadePopups" 1.5 "quick" {})
      (h.anim "fadePopupsIn" 1.5 "quick" {})
      (h.anim "fadePopupsOut" 1.2 "quick" {})
      (h.anim "zoomFactor" 3 "quick" {})
      (h.anim "monitorAdded" 3 "easeOutQuint" {})
    ];
  };
}
