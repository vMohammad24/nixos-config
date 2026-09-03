{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/system/desktop.nix
  ];

  networking.hostName = "main-desktop";

  myConfig.ai.enable = false;
  myConfig.desktops.hyprland.enable = true;
  services.moonshine.settings.compositor.gpu = "/dev/dri/by-path/pci-0000:03:00.0-render";
  myConfig.rffmpeg = {
    enable = true;
    role = "worker";
    interface = "enp5s0";
    vaapiRenderDevice = "/dev/dri/by-path/pci-0000:03:00.0-render";
    vaapiVendorId = "0x1002";
  };

  specialisation = {
    mango.configuration = {
      system.nixos.tags = ["mango"];
      myConfig.desktops.hyprland.enable = lib.mkForce false;
      myConfig.desktops.mango.enable = true;
    };
    niri.configuration = {
      system.nixos.tags = ["niri"];
      myConfig.desktops.hyprland.enable = lib.mkForce false;
      myConfig.desktops.mango.enable = lib.mkForce false;
      myConfig.desktops.niri.enable = true;
    };
  };
}
