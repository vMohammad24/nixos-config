{pkgs, ...}: {
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

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      nixd
      biome
    ];
    extensions = [
      "biome"
      "ini"
      "rainbow-csv"
      "svelte"
      "html"
      "nix"
      "toml"
    ];
    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      session = {
        trust_all_worktrees = true;
      };
      auto_update = false;
      project_panel = {
        hide_gitignore = true;
        dock = "right";
      };
    };
  };

  home.packages = with pkgs; [
    bun
    nodejs_25
    cargo
    rustc
  ];
}
