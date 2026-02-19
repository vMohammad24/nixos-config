{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.monitor = [
    "DP-2, 2560x1440@240, 0x0, 1, , 1"
    "HDMI-A-1, 1920x1080@60, -1080x0, 1, transform, 1"
  ];
}
