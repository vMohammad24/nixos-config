{
  config,
  pkgs,
  ...
}: let
  t = config.theme;
in {
  programs.kitty = {
    enable = true;
    themeFile = t.name;
    settings = {
      font_family = t.font.name;
      font_size = 12;
      background_opacity = "0.95";
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "ctrl+plus" = "change_font_size all +1";
      "ctrl+equal" = "change_font_size all +1";
      "ctrl+kp_add" = "change_font_size all +1";
      "ctrl+minus" = "change_font_size all -1";
      "ctrl+underscore" = "change_font_size all -1";
      "ctrl+kp_subtract" = "change_font_size all -1";
      "ctrl+0" = "change_font_size all 0";
      "ctrl+kp_0" = "change_font_size all 0";
      "ctrl+l" = "clear_terminal scroll active";
    };
  };
}
