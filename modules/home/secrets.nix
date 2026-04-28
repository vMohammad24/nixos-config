{
  age = {
    identityPaths = ["/home/vmohammad/.ssh/id_rsa"];
    secrets = {
      nest_api_key = {
        file = ../../secrets/nest_api_key.age;
      };
    };
  };
}
