{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
    "uwsm app -- udiskie --autostart --tray --notify"
    "uwsm app -- wl-paste --watch cliphist store"
    "gsettings set org.gnome.desktop.interface gtk-theme 'rose-pine'"
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
    "gsettings set org.gnome.desktop.interface icon-theme 'rose-pine'"
    "gsettings set org.gnome.desktop.interface cursor-theme 'rose-pine-hyprcursor'"
  ];
}
