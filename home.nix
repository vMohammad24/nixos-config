{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    ./modules/home/core.nix
    ./modules/home/shell
    ./modules/home/terminal/kitty.nix
    ./modules/home/theme
    ./modules/home/services/vicinae.nix
    ./modules/home/services/hyprpaper.nix
    ./modules/home/services/hypridle.nix
    ./modules/home/services/hyprlock.nix
    ./modules/home/services/mako.nix
    ./modules/home/programs/git.nix
    ./modules/home/programs/waybar
    ./modules/home/programs/wlogout.nix
    ./modules/home/windowManager/hyprland
  ];
}
