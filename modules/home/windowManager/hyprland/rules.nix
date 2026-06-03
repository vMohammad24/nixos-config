{...}: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      {
        name = "firefox-pip";
        float = true;
        pin = true;
        suppress_event = ["fullscreen" "maximize"];
        "match:class" = "^(firefox)$";
        "match:title" = "^(Picture-in-Picture)$";
      }
    ];
  };
}
