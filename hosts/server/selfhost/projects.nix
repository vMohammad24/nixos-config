{...}: {
  services.postgresql = {
    enable = true;
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
