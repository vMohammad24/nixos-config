{
  pkgs,
  lib,
  ...
}: let
  ladspa = lib.makeSearchPath "lib/ladspa" [pkgs.ladspaPlugins pkgs.rnnoise-plugin];
  lv2 = "${pkgs.calf}/lib/lv2";
in {
  home.packages = [pkgs.ladspaPlugins pkgs.rnnoise-plugin pkgs.calf];

  systemd.user.services.voice-chain = {
    Unit = {
      Description = "PipeWire voice-processing chain (QuadCast S)";
      After = ["pipewire.service"];
      Requires = ["pipewire.service"];
      PartOf = ["pipewire.service"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.pipewire}/bin/pipewire -c ${./voice-chain.conf}";
      Environment = [
        "LADSPA_PATH=${ladspa}"
        "LV2_PATH=${lv2}"
      ];
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["default.target"];
  };
}
