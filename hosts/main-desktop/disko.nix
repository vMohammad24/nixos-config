{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:06:00.0-nvme-1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0022" "dmask=0022"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "bcachefs";
                filesystem = "main";
                label = "nvme.msi";
              };
            };
          };
        };
      };
      sata = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:17.0-ata-8";
        content = {
          type = "gpt";
          partitions = {
            pool = {
              size = "100%";
              content = {
                type = "bcachefs";
                filesystem = "main";
                label = "sata.kc600";
              };
            };
          };
        };
      };
    };
    bcachefs_filesystems.main = {
      type = "bcachefs_filesystem";
      mountpoint = "/";
      extraFormatArgs = [
        "--foreground_target=nvme.msi"
        "--promote_target=nvme.msi"
        "--metadata_target=nvme.msi"
        "--background_target=sata.kc600"
      ];
    };
  };
}
