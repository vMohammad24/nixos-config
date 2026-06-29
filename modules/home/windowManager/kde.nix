{config, ...}: let
  launch = name: key: command: {
    inherit key command;
    name = "Launch ${name}";
  };
in {
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      wallpaper = "${config.stylix.image}";
    };

    hotkeys.commands = {
      "launch-kitty" = launch "Kitty" "Meta+T" "kitty";
      "launch-firefox" = launch "Firefox" "Meta+W" "firefox";
      "launch-thunar" = launch "Thunar" "Meta+E" "thunar";
      "launch-zed" = launch "Zed" "Meta+Shift+Z" "zeditor";
      "launch-steam" = launch "Steam" "Meta+Shift+S" "steam";
      "launch-prismlauncher" = launch "Prism Launcher" "Meta+Shift+P" "prismlauncher";
      "launch-feishin" = launch "Feishin" "Meta+Shift+T" "feishin";
      "launch-discord" = launch "Discord" "Meta+Shift+E" "discordcanary";
      "vicinae-toggle" = {
        name = "Vicinae Toggle";
        key = "Meta";
        command = "vicinae toggle";
      };
      "vicinae-clipboard" = {
        name = "Vicinae Clipboard";
        key = "Meta+V";
        command = "vicinae vicinae://extensions/vicinae/clipboard/history";
      };
      "vicinae-emoji" = {
        name = "Vicinae Emoji";
        key = "Meta+,";
        command = "vicinae vicinae://extensions/vicinae/core/search-emojis";
      };
      "framr" = {
        name = "Framr";
        key = "Print";
        command = "framr -u -c -a";
      };
      "power-menu" = {
        name = "Power Menu";
        key = "Ctrl+Alt+Delete";
        command = "vicinae deeplink vicinae://launch/power";
      };
    };

    shortcuts = {
      "services/plasma-manager-commands.desktop"."launch-kitty" = "Meta+T";
      "services/plasma-manager-commands.desktop"."launch-firefox" = "Meta+W";
      "services/plasma-manager-commands.desktop"."launch-thunar" = "Meta+E";
      "services/plasma-manager-commands.desktop"."launch-zed" = "Meta+Shift+Z";
      "services/plasma-manager-commands.desktop"."launch-steam" = "Meta+Shift+S";
      "services/plasma-manager-commands.desktop"."launch-prismlauncher" = "Meta+Shift+P";
      "services/plasma-manager-commands.desktop"."launch-feishin" = "Meta+Shift+T";
      "services/plasma-manager-commands.desktop"."launch-equibop" = "Meta+Shift+E";
      "services/plasma-manager-commands.desktop"."vicinae-toggle" = "Meta";
      "services/plasma-manager-commands.desktop"."vicinae-clipboard" = "Meta+V";
      "services/plasma-manager-commands.desktop"."vicinae-emoji" = "Meta+,";
      "services/plasma-manager-commands.desktop"."framr" = "Print";
      "services/plasma-manager-commands.desktop"."power-menu" = "Ctrl+Alt+Delete";

      "org.kde.klipper.desktop"."_launch" = "none";
      "org.kde.dolphin.desktop"."_launch" = "none";
    };
  };
}
