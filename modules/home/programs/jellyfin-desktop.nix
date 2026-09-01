{inputs, ...}: {
  imports = [inputs.jellyfin-desktop.homeModules.jellyfin-desktop];

  programs.jellyfin-desktop = {
    enable = true;
    settings = {
      serverUrl = "https://media.lan.vmohammad.dev/";
      transparentTitlebar = true;
      deviceName = "vmohammad nixos";
    };
  };
}
