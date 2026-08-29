{
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.gpu;
in {
  options.myConfig.gpu.enable = lib.mkEnableOption "the server's NVIDIA GPU";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.xserver.videoDrivers = ["nvidia"];

      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          open = true;
          nvidiaSettings = false;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };

      users.users = {
        vmohammad.extraGroups = ["video" "render"];
        jellyfin.extraGroups = lib.mkIf config.myConfig.rr.enable ["video" "render"];
      };
    })

    (lib.mkIf (!cfg.enable) {
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];

      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
    })
  ];
}
