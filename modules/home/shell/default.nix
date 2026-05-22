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
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l -g --icons";
      la = "eza -a --icons";
      ssh = "kitten ssh";
      nrb = "sudo nixos-rebuild switch --flake .#main-desktop";
    };
    loginShellInit = lib.mkIf (!osConfig.myConfig.desktops.kde.enable or true) ''
      if test "$XDG_VTNR" -eq 1 && uwsm check may-start
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
}
