{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.env = [
    "HYPRCURSOR_THEME,rose-pine-hyprcursor"
    "HYPRCURSOR_SIZE,24"
    "GTK_THEME,rose-pine"
  ];
}
