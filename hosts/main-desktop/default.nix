{...}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/system/desktop.nix
  ];

  networking.hostName = "main-desktop";

  myConfig.ai.enable = true;
  myConfig.desktops.hyprland.enable = true;
  myConfig.desktops.mango.enable = false;
  myConfig.desktops.niri.enable = false;
  services.moonshine.settings.compositor.gpu = "/dev/dri/by-path/pci-0000:03:00.0-render";
  myConfig.rffmpeg = {
    enable = true;
    role = "worker";
    interface = "enp5s0";
    vaapiVendorId = "0x1002";
  };
}
