{
  config,
  pkgs,
  ...
}: let
  c = config.theme.colors;
  t = config.theme;
in {
  services.mako = {
    enable = true;
    settings = {
      margin = 10;
      border-color = "#${c.overlay}";
      border-radius = 10;
      width = 400;
      font = "${t.font.name} ${toString t.font.size}";
      background-color = "#${c.surface}";
      icons = true;
      default-timeout = 5000;
    };
  };
}
