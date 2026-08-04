{...}: {
  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      nest_api_key = {
        file = ../../secrets/nest_api_key.age;
        mode = "0400";
        owner = "vmohammad";
        group = "users";
      };
      nix_conf = {
        file = ../../secrets/nix_conf.age;
        mode = "0400";
        owner = "vmohammad";
        group = "users";
      };
    };
  };
}
