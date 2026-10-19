{pkgs, ...}: {
  wayland.windowManager.mango.autostart_sh = ''
    uwsm finalize MANGO_INSTANCE_SIGNATURE ADW_DISABLE_PORTAL NIXOS_OZONE_WL
    uwsm app -- ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent &
    uwsm app -- udiskie --autostart --tray --notify &
    uwsm app -- steam -silent &
  '';
}
