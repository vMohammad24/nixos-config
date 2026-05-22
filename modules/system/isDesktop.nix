{
  config,
  lib,
  ...
}: {
  options.myConfig.isDesktop = lib.mkOption {
    type = lib.types.bool;
    default = config.myConfig.desktops.hyprland.enable or config.myConfig.desktops.kde.enable or false;
    description = "Whether the system is a desktop system.";
  };
}
