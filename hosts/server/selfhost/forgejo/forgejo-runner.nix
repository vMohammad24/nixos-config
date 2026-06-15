{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.forgejo-runner;
  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "forgejo-runner-config.yaml" cfg.settings;
in {
  options.services.forgejo-runner = {
    enable = lib.mkEnableOption "Forgejo Actions Runner";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.forgejo-runner;
      defaultText = lib.literalExpression "pkgs.forgejo-runner";
      description = "The forgejo-runner package to use.";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "forgejo-runner";
      description = "User account under which forgejo-runner runs.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "forgejo-runner";
      description = "Group under which forgejo-runner runs.";
    };
    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/forgejo-runner";
      description = "Directory for forgejo-runner to store its state (logs, workspaces, cache, etc.).";
    };
    hostPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [bash coreutils curl gawk gitMinimal gnused nodejs wget gnutar zstd jq]; # zstd & tar are required for cache to work, others are common for runners but not strictly required. (e.x actions wont work if node isnt avaliable.)
      description = "Packages to add to the PATH of the runner (useful for 'host' type labels).";
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = {};
      description = ''
        Declarative configuration for the forgejo-runner daemon.
        These options map directly to config.yaml.
      '';
      example = {
        runner.capacity = 2;
        server.connections.my-forgejo = {
          url = "https://forgejo.example.com/";
          token = "your-token-here"; # token_url works better for secrets management (file:///path/to/token)
          labels = ["ubuntu-latest:docker://node:26-bookworm"]; # if you use a host label, it will be in a systemd sandbox, docker access is permited to it, use hostPackages to add tools for it.
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      # NOTE: only Docker is configured; rootless Podman requires manual config.
      extraGroups = lib.optional config.virtualisation.docker.enable "docker";
    };
    users.groups.${cfg.group} = {};
    systemd.services.forgejo-runner = {
      description = "Forgejo Actions Runner Daemon";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after =
        ["network-online.target"]
        ++ lib.optional config.virtualisation.docker.enable "docker.service";
      path = cfg.hostPackages;
      environment = {
        HOME = cfg.stateDir;
      };

      startLimitIntervalSec = 60;
      startLimitBurst = 5;
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = baseNameOf cfg.stateDir;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${lib.getExe cfg.package} daemon --config ${configFile}";
        Restart = "on-failure";
        RestartSec = "2s";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };
  };
}
