{lib, ...}: let
  h = import ./helpers.nix {inherit lib;};
in {
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      (h.windowRule "firefox-pip"
        {
          class = "^(firefox)$";
          title = "^(Picture-in-Picture)$";
        }
        {
          float = true;
          pin = true;
          suppress_event = "fullscreen maximize";
        })
    ];

    layer_rule = [
      (h.layerRule "notification-slide" {namespace = "notifications";} {animation = "slide right";})
      (h.layerRule "vicinae-popin" {namespace = "vicinae";} {animation = "popin 85%";})
    ];
  };
}
