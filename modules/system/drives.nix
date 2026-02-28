{...}: {
  boot.supportedFilesystems = ["ntfs"];

  fileSystems."/mnt/SSSD" = {
    device = "/dev/disk/by-uuid/C2E8DF9EE8DF8ED3";
    fsType = "ntfs-3g";
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
    fsType = "ntfs-3g";
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
    fsType = "ntfs-3g";
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
