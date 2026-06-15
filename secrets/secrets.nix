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
}
