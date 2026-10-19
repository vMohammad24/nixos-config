{...}: {
  wayland.windowManager.mango.settings.env = [
    "ADW_DISABLE_PORTAL,1"
    "NIXOS_OZONE_WL,1"
  ];
}
