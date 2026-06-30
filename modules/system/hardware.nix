{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.myConfig.isDesktop {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };

    hardware.openrazer.enable = true;
    hardware.openrazer.users = ["vmohammad"];
    environment.systemPackages = [pkgs.openrazer-daemon];

    services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];

    boot.initrd.kernelModules = [
      "amdgpu"
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
    };

    # WlMouse (beast) 8k dongle
    services.udev.extraRules = ''
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36a7", ATTRS{idProduct}=="a868", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="36a7", ATTRS{idProduct}=="a868", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36a7", ATTRS{idProduct}=="a869", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="36a7", ATTRS{idProduct}=="a869", MODE="0666", TAG+="uaccess"
    '';

    boot.supportedFilesystems = ["ntfs3"];

    fileSystems."/mnt/SSSD" = {
      device = "/dev/disk/by-uuid/8b556154-5ed1-478c-94e0-38567f794758";
      fsType = "xfs";
      options = [
        "defaults"
        "noatime"
        "nofail"
        "x-gvfs-show"
      ];
    };
  };
}
