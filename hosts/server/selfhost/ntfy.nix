{...}: let
  inherit (import ./constants.nix) internalDomain servicePorts;
in {
  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.${internalDomain}";
      listen-http = "127.0.0.1:${toString servicePorts.ntfy}";
      behind-proxy = true;

      cache-duration = "12h";
      attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
      attachment-total-size-limit = "5G";
      attachment-file-size-limit = "15M";
      attachment-expiry-duration = "3h";

      keepalive-interval = "45s";
      manager-interval = "1m";
      log-level = "info";
    };
  };
}
