{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
      starship init fish | source
      zoxide init fish --cmd cd | source
    '';
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l -g --icons";
      la = "eza -a --icons";
    };
    loginShellInit = ''
      if test "$XDG_VTNR" -eq 1 && uwsm check may-start
          exec uwsm start hyprland-uwsm.desktop
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };
}
