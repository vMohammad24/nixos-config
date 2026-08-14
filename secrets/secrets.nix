let
  vmohammad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEJ9n6DsebwwOlxuKwV+4RUIxPxhhBRItY7PEWj13cl vmohammad@nixos";
  main-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtWGg/KGLN4pDCEDfuKwKIOqh+YBAH+KfKdEPahTs75 root@main-desktop";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFcSTRb+Xe3g5trC7PzqU8ZKagiV4oTqvrTwzWqpE/+ root@server";
  users = [vmohammad];
  systems = [main-desktop server];
in {
  "nest_api_key.age".publicKeys = users ++ systems;
  "cloudflared.age".publicKeys = [vmohammad server];
  "tss.age".publicKeys = [vmohammad server];
  "heliopolis-runner-token.age".publicKeys = [vmohammad server];
  "mullvad-wg.age".publicKeys = [vmohammad server];
  "prowlarr-milkie-apikey.age".publicKeys = [vmohammad server];
  "prowlarr-torrentleech-password.age".publicKeys = [vmohammad server];
  "prowlarr-torrentleech-2fa.age".publicKeys = [vmohammad server];
  "prowlarr-seedpool-apikey.age".publicKeys = [vmohammad server];
  "grafana-secret-key.age".publicKeys = [vmohammad server];
  "miniflux-admin.age".publicKeys = [vmohammad server];
  "speedtest-tracker-key.age".publicKeys = [vmohammad server];
  "nix_conf.age".publicKeys = [vmohammad main-desktop];
  "restic-local-password.age".publicKeys = [vmohammad server];
  "restic-s3-env.age".publicKeys = [vmohammad server];
  "alertmanager-discord-env.age".publicKeys = [vmohammad server];
}
