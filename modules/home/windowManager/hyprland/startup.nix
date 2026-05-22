{pkgs, ...}: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
    "uwsm app -- udiskie --autostart --tray --notify"
    "uwsm app -- steam -silent"
  ];
}
