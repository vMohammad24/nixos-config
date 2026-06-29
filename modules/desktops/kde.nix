{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.myConfig.desktops.kde;
in {
  options.myConfig.desktops.kde = {
    enable = lib.mkEnableOption "KDE Plasma 6 environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    stylix.targets.qt.enable = false;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      spectacle
    ];

    home-manager.users.vmohammad = {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
        ../../modules/home/windowManager/kde.nix
      ];
    };
  };
}
