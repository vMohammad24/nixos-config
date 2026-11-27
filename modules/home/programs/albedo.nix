{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.albedo.homeModules.default];

  programs.albedo.enable = true;

  services.albedo = {
    enable = true;
    web = {
      enable = true;
      port = 4317;
    };
    settings.extensions = {
      enabled = {
        honcho = true;
        mcp = true;
      };
      honcho = {
        endpoint = "https://honcho.lan.vmohammad.dev/";
        workspace = "hermes";
        humanPeer = "vmohammad";
        assistantPeer = "albedo";
      };
      mcp.servers = {
        blender = {
          type = "stdio";
          command = "${pkgs.mcp-for-blender}/bin/mcp-for-blender";
          enabled = true;
        };
        grafana = {
          type = "stdio";
          command = "${pkgs.mcp-grafana}/bin/mcp-grafana";
          env = {
            GRAFANA_URL = "https://grafana.lan.vmohammad.dev/";
          };
          enabled = true;
        };
      };
    };
  };

  home.file.".albedo/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/albedo/AGENTS.md";
  home.file.".albedo/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/albedo/skills";
}
