{
  config,
  lib,
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
    };

    home-manager.users.vmohammad = {
      imports = [
        ../../modules/home/windowManager/hyprland
        ../../modules/home/services/hyprpaper.nix
        ../../modules/home/services/hypridle.nix
        ../../modules/home/services/hyprlock.nix
        ../../modules/home/programs/bars/waybar.nix
        ../../modules/home/services/mako.nix
      ];
    };
  };
}
