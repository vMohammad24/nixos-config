{
  osConfig,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
    '';
    shellAliases =
      {
        ls = "eza --icons auto";
        ll = "eza -l -g --icons auto";
        la = "eza -a --icons auto";
        ssh = "kitten ssh";
        nrb =
          if osConfig.myConfig.isDesktop
          then "sudo nixos-rebuild switch --flake .#main-desktop"
          else "sudo nixos-rebuild switch --flake .#server";
      }
      // lib.optionalAttrs osConfig.myConfig.isDesktop {
        nrbs = "nh os switch . -H server --target-host vmohammad@192.168.1.31 --build-host localhost --elevation-strategy passwordless";
      };
    loginShellInit = lib.mkIf (!osConfig.myConfig.desktops.kde.enable or true) ''
      if set -q XDG_VTNR && test "$XDG_VTNR" -eq 1 && uwsm check may-start
        ${lib.optionalString (osConfig.myConfig.desktops.hyprland.enable or false) "exec uwsm start hyprland-uwsm.desktop"}
        ${lib.optionalString (osConfig.myConfig.desktops.mango.enable or false) "exec mango"}
      end
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  programs.devenv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza.enable = true;

  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "shell"
        "display"
        "de"
        "wm"
        "cursor"
        "terminal"
        "cpu"
        "gpu"
        {
          "type" = "command";
          "key" = "Mouse";
          "text" = "wl-mouse -j info | jq -r '\"\\(.name) @ \\(.battery_percent)%\"' | sed 's/ (dongle)//; s/ (wired)//'";
        }
        "memory"
        "swap"
        "disk"
        "break"
        "colors"
      ];
    };
  };
}
