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
      engines = [
        {
          name = "bing";
          disabled = false;
        }
        {
          name = "yandex";
          disabled = false;
        }
        {
          name = "mwmbl";
          disabled = false;
        }
        {
          name = "wiby";
          disabled = false;
        }

        {
          name = "wikidata";
          disabled = true;
        }
        {
          name = "qwant";
          disabled = true;
        }
        {
          name = "yahoo";
          disabled = true;
        }
        {
          name = "reuters";
          disabled = true;
        }
        {
          name = "mojeek";
          disabled = true;
        }
        {
          name = "crowdview";
          disabled = true;
        }
        {
          name = "pypi";
          disabled = true;
        }
        {
          name = "arch linux wiki";
          disabled = true;
        }
        {
          name = "kickass";
          disabled = true;
        }
        {
          name = "vimeo";
          disabled = true;
        }
        {
          name = "dailymotion";
          disabled = true;
        }
        {
          name = "bandcamp";
          disabled = true;
        }
        {
          name = "solidtorrents";
          disabled = true;
        }
        {
          name = "wttr.in";
          disabled = true;
        }
      ];
    };
  };
}
