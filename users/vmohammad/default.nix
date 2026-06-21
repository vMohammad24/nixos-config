{
  inputs,
  lib,
  osConfig,
  ...
}: {
  imports =
    [
      inputs.vicinae.homeManagerModules.default
      inputs.framr.homeManagerModules.default
      inputs.nix-index-database.homeModules.default
      ../../modules/home/core.nix
      ../../modules/home/shell
      ../../modules/home/theme
      ../../modules/home/programs/dev.nix
    ]
    ++ lib.optionals (osConfig.myConfig.desktops.hyprland.enable or false) [
      ../../modules/home/terminal/kitty.nix
      ../../modules/home/services/hyprpaper.nix
      ../../modules/home/services/hypridle.nix
      ../../modules/home/services/hyprlock.nix
      ../../modules/home/programs/bars/waybar.nix
      ../../modules/home/services/mako.nix
      ../../modules/home/services/vicinae.nix
    ]
    ++ lib.optionals (osConfig.myConfig.desktops.kde.enable or false) [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
