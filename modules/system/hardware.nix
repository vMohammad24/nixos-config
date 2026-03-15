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
    device = "/dev/disk/by-uuid/C2E8DF9EE8DF8ED3";
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

  fileSystems."/mnt/eSSD" = {
    device = "/dev/disk/by-uuid/4C08CBD108CBB86A";
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
