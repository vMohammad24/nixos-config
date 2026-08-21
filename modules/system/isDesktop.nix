{
  config,
  lib,
  ...
}: {
  options.myConfig.isDesktop = lib.mkOption {
    type = lib.types.bool;
    default =
      lib.any
      (desktop: config.myConfig.desktops.${desktop}.enable or false)
      ["hyprland" "mango" "niri"];
    description = "Whether the system is a desktop system.";
  };
}
