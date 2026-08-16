{
  config,
  lib,
  ...
}: {
  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = lib.mkMerge [
      {
        cloudflared = {
          file = ../../secrets/cloudflared.age;
          mode = "0400";
        };
        tss = {
          file = ../../secrets/tss.age;
          mode = "0400";
        };
        mullvad-wg = {
          file = ../../secrets/mullvad-wg.age;
          mode = "0400";
        };
      }
      (lib.mkIf config.myConfig.forgejo-runner.enable {
        heliopolis-runner-token = {
          file = ../../secrets/heliopolis-runner-token.age;
          mode = "0400";
          owner = "forgejo-runner";
          group = "forgejo-runner";
        };
      })
      (lib.mkIf config.myConfig.monitoring.enable {
        alertmanager-discord-env = {
          file = ../../secrets/alertmanager-discord-env.age;
          mode = "0400";
        };
        grafana-secret-key = {
          file = ../../secrets/grafana-secret-key.age;
          mode = "0400";
          owner = "grafana";
          group = "grafana";
        };
      })
      (lib.mkIf config.myConfig.backups.enable {
        restic-local-password = {
          file = ../../secrets/restic-local-password.age;
          mode = "0400";
        };
        restic-s3-env = {
          file = ../../secrets/restic-s3-env.age;
          mode = "0400";
        };
      })
      (lib.mkIf config.myConfig.rr.enable {
        prowlarr-milkie-apikey = {
          file = ../../secrets/prowlarr-milkie-apikey.age;
          mode = "0400";
          owner = "prowlarr";
          group = "prowlarr";
        };
        prowlarr-torrentleech-password = {
          file = ../../secrets/prowlarr-torrentleech-password.age;
          mode = "0400";
          owner = "prowlarr";
          group = "prowlarr";
        };
        prowlarr-torrentleech-2fa = {
          file = ../../secrets/prowlarr-torrentleech-2fa.age;
          mode = "0400";
          owner = "prowlarr";
          group = "prowlarr";
        };
        prowlarr-seedpool-apikey = {
          file = ../../secrets/prowlarr-seedpool-apikey.age;
          mode = "0400";
          owner = "prowlarr";
          group = "prowlarr";
        };
      })
    ];
  };
}
