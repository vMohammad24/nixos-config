{
  config,
  inputs,
  ...
}: {
  imports = [inputs.tangled.nixosModules.knot-rs];

  services.tangled.knot-rs = {
    enable = true;
    openFirewall = false;
    environmentFile = config.age.secrets.knot-env.path;
    settings = {
      server = {
        hostname = "knot.vmohammad.dev";
        admins = ["did:plc:yqnztm6mvqzv4nsjfv42kfri"];
        listen_addr = "0.0.0.0:2584";
        ssh_listen_addr = "0.0.0.0:2222";
      };
      atproto.plc_directory = "https://plc.directory";
      contact.email = "vmohammad@vmohammad.dev";
      git.object_format = "sha1";
      xrpc = {
        trusted_proxy_header = "x-forwarded-for";
        trusted_proxies = ["100.113.255.179"];
      };
    };
  };
}
