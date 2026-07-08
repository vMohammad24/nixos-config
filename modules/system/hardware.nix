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

    powerManagement.cpuFreqGovernor = "performance";

    hardware.openrazer.enable = true;
    hardware.openrazer.users = ["vmohammad"];
    environment.systemPackages = [pkgs.openrazer-daemon];

    services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];

    boot.initrd.kernelModules = [
      "amdgpu"
      "usbmon"
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
    };

    services.udev.extraRules = ''
      # WlMouse (beast) 8k dongle
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36a7", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="36a7", MODE="0666", TAG+="uaccess"

      # Razer Huntsman TKL V2 (1532:026B) - force 8kHz polling rate
      SUBSYSTEM=="hid", KERNEL=="0003:1532:026B.*", ATTR{poll_rate}="8000"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="026b", TEST=="power/control", ATTR{power/control}="on", ATTR{power/autosuspend_delay_ms}="-1"
    '';

    boot.supportedFilesystems = ["ntfs3"];

    fileSystems."/mnt/SSSD" = {
      device = "/dev/disk/by-uuid/e18c8ef6-e3e8-42d8-be39-0fa459c4f94c";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "nofail"
        "x-gvfs-show"
      ];
    };
  };
}
