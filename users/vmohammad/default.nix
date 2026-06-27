{
  inputs,
  lib,
  osConfig,
  ...
}: {
  imports =
    [
      inputs.nix-index-database.homeModules.default
      inputs.framr.homeManagerModules.default
      ../../modules/home/core.nix
      ../../modules/home/shell
      ../../modules/home/programs/dev.nix
    ]
    ++ lib.optionals osConfig.myConfig.isDesktop [
      inputs.vicinae.homeManagerModules.default
      ../../modules/home/theme
      ../../modules/home/services/mako.nix
      ../../modules/home/services/vicinae.nix
      ../../modules/home/terminal/kitty.nix
    ]
    ++ lib.optionals (osConfig.myConfig.desktops.hyprland.enable or false) [
      ../../modules/home/services/hyprpaper.nix
      ../../modules/home/services/hypridle.nix
      ../../modules/home/services/hyprlock.nix
      ../../modules/home/programs/bars/waybar.nix
    ]
    ++ lib.optionals (osConfig.myConfig.desktops.kde.enable or false) [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
