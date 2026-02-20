{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "vMohammad24";
        email = "62218284+vMohammad24@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };
}
