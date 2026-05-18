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
      inputs.agenix.homeManagerModules.default
      ./modules/home/secrets.nix
      ./modules/home/core.nix
      ./modules/home/shell
      ./modules/home/terminal/kitty.nix
      ./modules/home/theme
      ./modules/home/services/vicinae.nix
      ./modules/home/programs/dev.nix
    ]
    ++ lib.optionals (osConfig.myConfig.desktop != "kde") [
      ./modules/home/services/hyprpaper.nix
      ./modules/home/services/hypridle.nix
      ./modules/home/services/hyprlock.nix
      ./modules/home/services/mako.nix
      ./modules/home/programs/waybar
    ]
    ++ lib.optionals (osConfig.myConfig.desktop == "hyprland") [
      ./modules/home/windowManager/hyprland
    ]
    ++ lib.optionals (osConfig.myConfig.desktop == "mango") [
      ./modules/home/windowManager/mango
    ]
    ++ lib.optionals (osConfig.myConfig.desktop == "kde") [
      inputs.plasma-manager.homeModules.plasma-manager
      ./modules/home/windowManager/kde.nix
    ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
