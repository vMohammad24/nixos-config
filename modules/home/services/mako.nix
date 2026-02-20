{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    settings = {
        margin = 10;
        border-color = "#26233a";
        border-radius = 10;
        width = 400;
        font = "JetBrains Mono Medium 11";
        background-color = "#1f1d2e";
        icons = true;
        default-timeout = 5000;
    };
  };
}
