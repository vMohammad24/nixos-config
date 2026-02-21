{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.env = [
    "HYPRCURSOR_THEME,rose-pine-hyprcursor"
    "HYPRCURSOR_SIZE,24"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "ADW_DISABLE_PORTAL,1"
  ];
}
