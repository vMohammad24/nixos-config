{
  pkgs,
  inputs,
  ...
}: let
  monoFont = {
    package = pkgs.nerd-fonts.jetbrains-mono;
    name = "JetBrainsMono Nerd Font";
  };
in {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    image = ../wallpaper.png;

    targets.kmscon.enable = false;

    cursor = {
      package = pkgs.rose-pine-hyprcursor;
      name = "rose-pine-hyprcursor";
      size = 24;
    };

    fonts = {
      monospace = monoFont;
      sansSerif = monoFont;
      serif = monoFont;
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 12;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.85;
      terminal = 0.95;
    };
  };
}
