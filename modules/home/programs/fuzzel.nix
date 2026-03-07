{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        width = 40;
        icon-theme = "rose-pine";
      };
      border = {
        width = 2;
        radius = 4;
      };
    };
  };
}
