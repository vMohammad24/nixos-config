{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
    "hyprpaper"
    "mako"
    "wl-paste --watch cliphist store"
  ];
}
