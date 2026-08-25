{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.myConfig.desktops.hyprland;
in {
  options.myConfig.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland WM environment";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    home-manager.users.vmohammad = {
      imports = [
        ../../modules/home/windowManager/hyprland
      ];
    };
  };
}
