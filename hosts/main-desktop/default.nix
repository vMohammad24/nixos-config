{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/system/desktop.nix
  ];

  networking.hostName = "main-desktop";

  myConfig.ai.enable = false;
  myConfig.desktops.hyprland.enable = true;

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
