{lib, ...}: let
  mkColorOpt = name: default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
      description = "Rosé Pine ${name} color (hex without #)";
    };
in {
  options.theme = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "rose-pine";
      description = "Theme name used by GTK, icons, etc.";
    };

    font = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Primary font family";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 11;
        description = "Default font size";
      };
    };

    cursor = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "rose-pine-hyprcursor";
        description = "Cursor theme name";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = "Cursor size";
      };
    };

    rounding = lib.mkOption {
      type = lib.types.int;
      default = 6;
      description = "Global border rounding";
    };

    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.85;
      description = "Default background opacity for transparent elements";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "~/Pictures/wallpaper.png";
      description = "Path to wallpaper image";
    };

    colors = {
      base = mkColorOpt "base" "191724";
      surface = mkColorOpt "surface" "1f1d2e";
      overlay = mkColorOpt "overlay" "26233a";
      muted = mkColorOpt "muted" "6e6a86";
      subtle = mkColorOpt "subtle" "908caa";
      text = mkColorOpt "text" "e0def4";
      love = mkColorOpt "love" "eb6f92";
      gold = mkColorOpt "gold" "f6c177";
      rose = mkColorOpt "rose" "ebbcba";
      pine = mkColorOpt "pine" "31748f";
      foam = mkColorOpt "foam" "9ccfd8";
      iris = mkColorOpt "iris" "c4a7e7";
      highlightLow = mkColorOpt "highlightLow" "21202e";
      highlightMed = mkColorOpt "highlightMed" "403d52";
      highlightHigh = mkColorOpt "highlightHigh" "524f67";
    };
  };
}
