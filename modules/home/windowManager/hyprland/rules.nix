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
    layerrule = [
      {
        name = "vicinae-blur";
        blur = true;
        ignore_alpha = 0;
        "match:namespace" = "vicinae";
      }
    ];
  };
}
