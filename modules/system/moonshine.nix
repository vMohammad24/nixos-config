{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  isDesktop = config.myConfig.isDesktop;
  steam = "/run/current-system/sw/bin/steam";
  krita = lib.getExe pkgs.krita;
  stopDesktopSteam = pkgs.writeShellApplication {
    name = "moonshine-stop-desktop-steam";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.procps
    ];
    text = ''
      if pgrep -x steam >/dev/null; then
        ${steam} -shutdown >/dev/null 2>&1 || true

        for ((attempt = 0; attempt < 30; attempt++)); do
          if ! pgrep -x steam >/dev/null; then
            exit 0
          fi
          sleep 1
        done

        echo "Timed out waiting for the desktop Steam instance to stop" >&2
        exit 1
      fi
    '';
  };
  stopDesktopSteamCommand = [[(lib.getExe stopDesktopSteam)]];
in {
  imports = [inputs.moonshine.nixosModules.default];

  config = lib.mkIf isDesktop {
    services.moonshine = {
      enable = true;
      user = "vmohammad";
      uid = 1000;
      openFirewall = true;
      logFilter = "moonshine=info,moonshine_core::tls=error";
      settings = {
        name = config.networking.hostName;
        application = [
          {
            title = "Steam Big Picture";
            command = [steam "steam://open/bigpicture"];
            pre_command = stopDesktopSteamCommand;
            stdout = "journal";
            stderr = "journal";
            launch_timeout_secs = 10;
          }
          {
            title = "Krita";
            command = [krita];
            stdout = "journal";
            stderr = "journal";
            launch_timeout_secs = 10;
          }
        ];
        application_scanner = [
          {
            type = "steam";
            library = "$HOME/.local/share/Steam";
            command = [steam "-bigpicture" "steam://rungameid/{game_id}"];
            pre_command = stopDesktopSteamCommand;
            stdout = "journal";
            stderr = "journal";
            launch_timeout_secs = 10;
          }
        ];
        compositor.hdr = true;
      };
    };

    networking.firewall.allowedUDPPorts = [5353];

    users.users.vmohammad.extraGroups = [
      "input"
      "moonshine"
      "render"
      "video"
    ];
  };
}
