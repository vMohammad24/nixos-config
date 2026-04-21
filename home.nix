{inputs, ...}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.nix-index-database.homeModules.default
    ./modules/home/core.nix
    ./modules/home/shell
    ./modules/home/terminal/kitty.nix
    ./modules/home/theme
    ./modules/home/services/vicinae.nix
    ./modules/home/services/hyprpaper.nix
    ./modules/home/services/hypridle.nix
    ./modules/home/services/hyprlock.nix
    ./modules/home/services/mako.nix
    ./modules/home/programs/dev.nix
    ./modules/home/programs/waybar
    ./modules/home/windowManager/hyprland
  ];
  
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
