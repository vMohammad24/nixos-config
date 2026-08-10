{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.tss.nixosModules.default];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureDatabases = ["tss"];
    ensureUsers = [
      {
        name = "tss";
        ensureDBOwnership = true;
      }
    ];
  };

  services.tss = {
    enable = true;
    port = 3000;
    envFile = "/run/agenix/tss";
  };
}
