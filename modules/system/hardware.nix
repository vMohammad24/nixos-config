{config, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    # NVIDIA <3
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    EGL_PLATFORM = "wayland";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
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

  fileSystems."/mnt/eSSD" = {
    device = "/dev/disk/by-uuid/9c35301d-c3e9-4982-8048-090861bab459";
    fsType = "xfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/mnt/why" = {
    device = "/dev/disk/by-uuid/2E783FBE783F841D";
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=000"
      "exec"
      "nofail"
      "x-gvfs-show"
    ];
  };
}
