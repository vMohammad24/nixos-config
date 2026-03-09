{...}: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "match:class ^(firefox)$, match:title ^(Picture-in-Picture)$, float on, pin on, suppress_event fullscreen maximize"
    ];
  };
}
