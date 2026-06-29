{inputs, ...}: {
  imports = [inputs.jellyfin-desktop.homeModules.jellyfin-desktop];

  programs.jellyfin-desktop = {
    enable = true;
    settings = {
      serverUrl = "https://media.creations.works/";
      transparentTitlebar = true;
      deviceName = "vMohammad's PC";
    };
  };
}
