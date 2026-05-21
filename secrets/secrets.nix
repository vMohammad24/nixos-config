let
  vmohammad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEJ9n6DsebwwOlxuKwV+4RUIxPxhhBRItY7PEWj13cl vmohammad@nixos";
  main-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtWGg/KGLN4pDCEDfuKwKIOqh+YBAH+KfKdEPahTs75 root@main-desktop";
  users = [vmohammad];
  systems = [main-desktop];
in {
  "nest_api_key.age".publicKeys = users ++ systems;
}
