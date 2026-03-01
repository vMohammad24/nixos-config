{
  config,
  pkgs,
  ...
}: let
  c = config.theme.colors;
  t = config.theme;
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        width = 40;
        font = "${t.font.name}:size=14";
        icon-theme = t.name;
      };
      colors = {
        background = "${c.base}fa";
        text = "${c.text}ff";
        match = "${c.rose}ff";
        selection = "${c.overlay}ff";
        selection-text = "${c.text}ff";
        border = "${c.rose}ff";
      };
      border = {
        width = 2;
        radius = 4;
      };
    };
  };
}
