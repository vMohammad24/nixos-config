{
  inputs,
  lib,
  osConfig,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.framr.homeManagerModules.default
    inputs.nix-index-database.homeModules.default
    ../../modules/home/core.nix
    ../../modules/home/shell
    ../../modules/home/terminal/kitty.nix
    ../../modules/home/theme
    ../../modules/home/services/vicinae.nix
    ../../modules/home/programs/dev.nix
  ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
