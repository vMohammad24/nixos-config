{pkgs, lib, ...}: let
  pkg = pkgs.linux-trackpad-driver;
in {
  services.udev.packages = [pkg];
  systemd.packages = [pkg];

  systemd.services.linux-trackpad-driver = {
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = [
      ""
      "${pkg}/bin/ltd run"
    ];
  };
  systemd.services."linux-trackpad-driver-reconnect@" = {
    serviceConfig.ExecStart = [
      ""
      "${pkg}/bin/ltd reconnect /dev/%I"
    ];
  };
}
