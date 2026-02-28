{
  config,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/Pictures/wallpaper.png";
          fit_mode = "cover";
        }
      ];
    };
  };
}
