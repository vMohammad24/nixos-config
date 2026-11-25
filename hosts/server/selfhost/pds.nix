{
  config,
  pkgs,
  ...
}: {
  services.tranquil-pds = {
    enable = true;
    package = pkgs.tranquil-pds.overrideAttrs (old: {
      version = "0.9.1-unstable-2026-11-25";
      src = pkgs.fetchFromTangled {
        did = "did:plc:jj6ajj6duxnlthwtnob4qyuv";
        rev = "e525559799fe17817cf56d2a173306fea04ed85b";
        hash = "sha256-6Dk+6hkIR7zXLVhmKiS4PDbj1QvYM4zRVpQeAPFhdaQ=";
      };
      cargoHash = "sha256-MHnKgrT30Wi4B+nlm8i0EVm++zK3Q1lZtExYNP2vsFU=";
      buildInputs = old.buildInputs ++ [pkgs.sqlite];
    });
    database.createLocally = true;
    environmentFiles = [
      config.age.secrets.tranquil-env.path
      config.age.secrets.tranquil-comms-env.path
    ];
    settings = {
      server = {
        hostname = "pds.vmohammad.dev";
        host = "0.0.0.0";
        port = 2583;
        user_handle_domains = ["vmohammad.dev"];
        contact_email = "vmohammad@vmohammad.dev";
        disable_account_verification_gate = true;
      };
      email = {
        from_address = "noreply@vmohammad.dev";
        from_name = "vmohammad.dev";
        smarthost = {
          host = "mail.creations.works";
          port = 465;
          tls = "implicit";
        };
      };
      firehose.crawlers = ["https://bsky.network"];
    };
  };
}
