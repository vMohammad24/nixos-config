{
  config,
  pkgs,
  ...
}: let
  t = config.theme;
in {
  wayland.windowManager.hyprland.settings.env = [
    "HYPRCURSOR_THEME,${t.cursor.name}"
    "HYPRCURSOR_SIZE,${toString t.cursor.size}"
    "ADW_DISABLE_PORTAL,1"
  ];
}
