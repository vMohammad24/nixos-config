{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "rose-pine";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.95";
      window_padding_width = 10;
    };
  };
}
