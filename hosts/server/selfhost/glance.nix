let
  myServices = [
    {
      title = "Jellyfin";
      url = "https://media.creations.works/";
      icon = "si:jellyfin";
    }
    {
      title = "Seer";
      url = "https://jellyseerr.creations.works/";
      icon = "sh:jellyseerr";
    }
    {
      title = "Vaultwarden";
      url = "https://vw.vmohammad.dev";
      icon = "si:bitwarden";
    }
    {
      title = "TidalSubSonic";
      url = "https://tidal.vmohammad.dev";
      icon = "si:tidal";
    }
  ];

  leftColumn = {
    size = "small";
    widgets = [
      {type = "clock";}
      {type = "calendar";}
      {
        type = "weather";
        location = "Amman, Jordan";
      }
      {
        type = "server-stats";
        servers = [
          {
            type = "local";
            name = "NixOS Server";
          }
        ];
      }
    ];
  };

  centerColumn = {
    size = "full";
    widgets = [
      {
        type = "search";
        search-engine = "duckduckgo";
        autofocus = true;
      }
      {
        type = "monitor";
        title = "Infrastructure";
        sites = myServices;
      }
      {
        type = "rss";
        title = "News & Releases";
        style = "detailed-list";
        feeds = [
          {
            url = "http://feeds.bbci.co.uk/news/world/rss.xml";
            title = "BBC News";
          }
          {
            url = "https://nixos.org/blog/announcements-rss.xml";
            title = "NixOS Announcements";
          }
        ];
      }
    ];
  };

  rightColumn = {
    size = "small";
    widgets = [
      {
        type = "bookmarks";
        title = "Quick Links";
        groups = [
          {
            title = "Development";
            links = [
              {
                title = "GitHub";
                url = "https://github.com/";
                icon = "si:github";
              }
              {
                title = "NixOS Search";
                url = "https://search.nixos.org";
                icon = "si:nixos";
              }
            ];
          }
        ];
      }
      {
        type = "reddit";
        subreddit = "selfhosted";
        show-thumbsnail = true;
        sort-by = "top";
        top-period = "day";
      }
    ];
  };
in {
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 8081;
      };
      pages = [
        {
          name = "Home";
          columns = [leftColumn centerColumn rightColumn];
        }
      ];
    };
  };
}
