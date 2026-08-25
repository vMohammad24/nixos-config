{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.backups;
  backupRoot = "/var/backup/server";
  postgresqlBackupDir = "/var/backup/postgresql";
  vaultwardenBackup = "${backupRoot}/vaultwarden";
  backupPaths =
    cfg.paths
    ++ lib.optionals config.myConfig.rr.enable ["/mnt/HDD/.state/nixarr"];
  metricsDir = "/var/lib/prometheus-node-exporter-text-files";

  recordBackupSuccess = pkgs.writeShellScript "record-restic-backup-success" ''
    set -eu
    backup_name="$1"
    metric_tmp="${metricsDir}/restic_backup_''${backup_name}.prom.tmp"
    ${pkgs.coreutils}/bin/printf \
      'restic_backup_last_success_timestamp_seconds{backup="%s"} %s\n' \
      "$backup_name" "$(${pkgs.coreutils}/bin/date +%s)" >"$metric_tmp"
    ${pkgs.coreutils}/bin/chmod 0644 "$metric_tmp"
    ${pkgs.coreutils}/bin/mv "$metric_tmp" \
      "${metricsDir}/restic_backup_''${backup_name}.prom"
  '';

  restoreTest = pkgs.writeShellScript "restic-restore-test" ''
    set -eu
    restore_root="$RUNTIME_DIRECTORY/restore"
    ${pkgs.coreutils}/bin/mkdir -p "$restore_root"
    ${pkgs.restic}/bin/restic restore latest \
      --no-cache \
      --include /var/backup/postgresql/all.sql \
      --target "$restore_root"
    ${pkgs.coreutils}/bin/test -s \
      "$restore_root/var/backup/postgresql/all.sql"
  '';

  mkRestoreTest = name: extra:
    lib.recursiveUpdate {
      description = "Restore-test the ${name} Restic backup";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "restic-restore-test-${name}";
        ExecStart = restoreTest;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    }
    extra;

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
        vaultwardenBackup
      ];
      description = "Server state paths to include.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${backupRoot} 0711 root root - -"
      "d /mnt/HDD/backups 0700 root root - -"
      "d ${metricsDir} 0755 root root - -"
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
        serviceConfig.ExecStartPost = "${recordBackupSuccess} local";
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
        serviceConfig.ExecStartPost = "${recordBackupSuccess} s3";
      };

      restic-restore-test-local = mkRestoreTest "local" {
        unitConfig.RequiresMountsFor = "/mnt/HDD";
        environment = {
          RESTIC_REPOSITORY = "/mnt/HDD/backups/restic-server";
          RESTIC_PASSWORD_FILE = config.age.secrets.restic-local-password.path;
        };
      };

      restic-restore-test-s3 = mkRestoreTest "s3" {
        serviceConfig.EnvironmentFile = config.age.secrets.restic-s3-env.path;
      };
    };

    systemd.timers = {
      restic-restore-test-local = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-01 05:00:00";
          Persistent = true;
          RandomizedDelaySec = "30m";
        };
      };
      restic-restore-test-s3 = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-01 06:00:00";
          Persistent = true;
          RandomizedDelaySec = "30m";
        };
      };
    };
  };
}
