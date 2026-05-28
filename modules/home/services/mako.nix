{...}: {
  services.mako = {
    enable = true;
    settings = {
      output = "DP-1";
      margin = 10;
      border-radius = 10;
      width = 400;
      icons = true;
      default-timeout = 5000;
    };
  };
}
