{...}: {
  services.speedtest-tracker = {
    enable = true;
    enableNginx = true;
    virtualHost = "speedtest.local";
    settings = {
      APP_KEY_FILE = "/run/agenix/speedtest-tracker-key";
      APP_URL = "http://speedtest.local";
    };
  };
}
