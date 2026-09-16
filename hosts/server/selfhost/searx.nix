{...}: let
  inherit (import ./constants.nix) internalDomain servicePorts;
in {
  services.searx = {
    enable = true;
    environmentFile = "/run/agenix/searx-secret-key";

    settings = {
      general.instance_name = "SearXNG";
      search.formats = ["html" "json"];
      server = {
        bind_address = "127.0.0.1";
        port = servicePorts.search;
        base_url = "https://search.${internalDomain}/";
        secret_key = "$SEARX_SECRET_KEY";
        limiter = false;
      };
    };
  };
}
