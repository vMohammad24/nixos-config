{
  config,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

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
    WLR_DRM_NO_ATOMIC = "1";
    RADV_PERFTEST = "gpl";
  };
}
