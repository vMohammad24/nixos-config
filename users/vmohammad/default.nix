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
    ]
    ++ lib.optionals osConfig.myConfig.isDesktop [
      inputs.vicinae.homeManagerModules.default
      ../../modules/home/theme
      ../../modules/home/programs/dev.nix
      ../../modules/home/services/mako.nix
      ../../modules/home/services/vicinae.nix
      ../../modules/home/services/hyprpaper.nix
      ../../modules/home/services/hypridle.nix
      ../../modules/home/services/hyprlock.nix
      ../../modules/home/terminal/kitty.nix
      ../../modules/home/programs/jellyfin-desktop.nix
      ../../modules/home/programs/bars/waybar.nix
    ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
