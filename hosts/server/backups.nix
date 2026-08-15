{
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.backups;
  backupRoot = "/var/backup/server";
  postgresqlBackupDir = "/var/backup/postgresql";
  vaultwardenBackup = "${backupRoot}/vaultwarden";
  backupPaths =
    cfg.paths
    ++ lib.optionals config.myConfig.rr.enable ["/mnt/HDD/.state/nixarr"];

  mkBackup = destination: {
    initialize = true;
    paths = backupPaths ++ ["${postgresqlBackupDir}/all.sql"];
    repository = destination.repository or null;
    passwordFile = destination.passwordFile or null;
    environmentFile = destination.environmentFile or null;
    timerConfig = destination.timerConfig;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 3"
    ];
    checkOpts = ["--read-data-subset=5%"];
  };
in {
  options.myConfig.backups = {
    enable = lib.mkEnableOption "encrypted Restic backups for server state";

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/var/lib/grafana"
        "/var/lib/speedtest-tracker"
        vaultwardenBackup
      ];
      description = "Server state paths to include.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${backupRoot} 0711 root root - -"
      "d /mnt/HDD/backups 0700 root root - -"
    ];

    services.vaultwarden.backupDir = vaultwardenBackup;

    services.postgresqlBackup = {
      enable = true;
      backupAll = true;
      location = postgresqlBackupDir;
      # restic already compresses htis
      compression = "none";
      startAt = "*-*-* 02:00:00";
    };

    services.restic.backups = {
      local = mkBackup {
        repository = "/mnt/HDD/backups/restic-server";
        passwordFile = config.age.secrets.restic-local-password.path;
        timerConfig = {
          OnCalendar = "*-*-* 03:00:00";
          Persistent = true;
          RandomizedDelaySec = "30m";
        };
      };

      s3 = mkBackup {
        environmentFile = config.age.secrets.restic-s3-env.path;
        timerConfig = {
          OnCalendar = "*-*-* 04:00:00";
          Persistent = true;
          RandomizedDelaySec = "30m";
        };
      };
    };

    systemd.services = {
      restic-backups-local = {
        requires = [
          "backup-vaultwarden.service"
          "postgresqlBackup.service"
        ];
        after = [
          "backup-vaultwarden.service"
          "postgresqlBackup.service"
        ];
        unitConfig.RequiresMountsFor = "/mnt/HDD";
      };
      restic-backups-s3 = {
        requires = [
          "backup-vaultwarden.service"
          "postgresqlBackup.service"
        ];
        after = [
          "backup-vaultwarden.service"
          "postgresqlBackup.service"
        ];
      };
    };
  };
}
