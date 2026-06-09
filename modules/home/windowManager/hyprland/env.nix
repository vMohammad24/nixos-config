{lib, ...}: let
  h = import ./helpers.nix {inherit lib;};
in {
  wayland.windowManager.hyprland.settings.env = [
    (h.env "ADW_DISABLE_PORTAL" "1")
  ];
}
