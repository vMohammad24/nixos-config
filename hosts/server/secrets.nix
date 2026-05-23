{...}: {
  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      cloudflared = {
        file = ../../secrets/cloudflared.age;
        mode = "0400";
      };
    };
  };
}
