{
  pkgs,
  lib,
  ...
}: let
  h = import ./helpers.nix {inherit lib;};
in {
  wayland.windowManager.hyprland.settings.on = [
    (h.onStart [
      "uwsm app -- ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
      "uwsm app -- udiskie --autostart --tray --notify"
      "uwsm app -- steam -silent"
    ])
  ];
}
