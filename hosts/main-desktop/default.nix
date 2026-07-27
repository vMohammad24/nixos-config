{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  networking.hostName = "main-desktop";

  myConfig.ai.enable = true;
  myConfig.desktops.hyprland.enable = true;

  specialisation = {
    kde.configuration = {
      system.nixos.tags = ["kde"];
      myConfig.desktops.hyprland.enable = lib.mkForce false;
      myConfig.desktops.kde.enable = true;
    };

    mango.configuration = {
      system.nixos.tags = ["mango"];
      myConfig.desktops.hyprland.enable = lib.mkForce false;
      myConfig.desktops.mango.enable = true;
    };
  };
}
