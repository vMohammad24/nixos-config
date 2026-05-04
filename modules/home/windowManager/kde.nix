{config, ...}: {
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      wallpaper = "${config.stylix.image}";
    };

    hotkeys.commands = {
      "launch-kitty" = {
        name = "Launch Kitty";
        key = "Meta+T";
        command = "kitty";
      };
      "launch-firefox" = {
        name = "Launch Firefox";
        key = "Meta+W";
        command = "firefox";
      };
      "launch-thunar" = {
        name = "Launch Thunar";
        key = "Meta+E";
        command = "thunar";
      };
      "launch-zed" = {
        name = "Launch Zed";
        key = "Meta+Shift+Z";
        command = "zeditor";
      };
      "launch-steam" = {
        name = "Launch Steam";
        key = "Meta+Shift+S";
        command = "steam";
      };
      "launch-prismlauncher" = {
        name = "Launch Prism Launcher";
        key = "Meta+Shift+P";
        command = "prismlauncher";
      };
      "launch-feishin" = {
        name = "Launch Feishin";
        key = "Meta+Shift+T";
        command = "feishin";
      };
      "launch-equibop" = {
        name = "Launch Equibop";
        key = "Meta+Shift+E";
        command = "equibop";
      };
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
