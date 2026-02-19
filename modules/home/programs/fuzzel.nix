{
  config,
  pkgs,
  ...
}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        width = 40;
        font = "JetBrainsMono Nerd Font:size=14";
        icon-theme = "rose-pine";
      };
      colors = {
        background = "191724fa";
        text = "e0def4ff";
        match = "ebbcbaff";
        selection = "26233aff";
        selection-text = "e0def4ff";
        border = "ebbcbaff";
      };
      border = {
        width = 2;
        radius = 4;
      };
    };
  };
}
