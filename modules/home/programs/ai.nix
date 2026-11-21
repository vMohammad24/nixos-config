{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home.packages = [pkgs.deepseek-harness];

  systemd.user.services.dsh-web = lib.mkIf osConfig.myConfig.isDesktop {
    Unit = {
      Description = "DeepSeek Harness web UI";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };
    Service = {
      Type = "simple";
      WorkingDirectory = "%h";
      ExecStart = "${pkgs.deepseek-harness}/bin/dsh web --no-open --host 127.0.0.1 --port 3080 --trusted-host localhost:3080 --trusted-host 127.0.0.1:3080";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["default.target"];
  };
}
