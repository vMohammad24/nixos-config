{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/home/core.nix
    ./modules/home/shell
    ./modules/home/terminal/kitty.nix
    ./modules/home/theme
    ./modules/home/services/hyprpaper.nix
    ./modules/home/programs/fuzzel.nix
    ./modules/home/programs/git.nix
    ./modules/home/programs/waybar
    ./modules/home/windowManager/hyprland
  ];
}
