{pkgs, ...}: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
    "uwsm app -- udiskie --autostart --tray --notify"
    "uwsm app -- vicinae server"
    "uwsm app -- steam -silent"
    "uwsm app -- equibop -m"
  ];
}
