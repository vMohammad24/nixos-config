{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/system/desktop.nix
  ];

  networking.hostName = "main-desktop";

  myConfig.ai.enable = true;
  myConfig.desktops.hyprland.enable = true;

  specialisation = {
    mango.configuration = {
      system.nixos.tags = ["mango"];
      myConfig.desktops.hyprland.enable = lib.mkForce false;
      myConfig.desktops.mango.enable = true;
    };
  };
}
