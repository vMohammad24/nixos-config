{pkgs, ...}: let
  src = pkgs.fetchzip {
    url = "https://github.com/rdavydov/Twitch-Channel-Points-Miner-v2/archive/8a35f87cd5345074003c7f6eedb48aedadc3b9b3.tar.gz";
    hash = "sha256-U+ltK9/fZSb3AromfrCGN8gLAASEcKuGhnscDr3TJyw=";
  };

  millify = pkgs.python313Packages.buildPythonPackage {
    pname = "millify";
    version = "0.1.1";
    format = "setuptools";
    src = pkgs.fetchzip {
      url = "https://files.pythonhosted.org/packages/source/m/millify/millify-0.1.1.tar.gz";
      hash = "sha256-3n1aF8kWmEsiSFrTh3tm6wsD9bEcGQV6GSkvOIzmko0=";
    };
  };

  python = pkgs.python313.withPackages (ps: [
    ps.requests
    ps.websocket-client
    ps.pillow
    ps.python-dateutil
    ps.emoji
    ps.colorama
    ps.irc
    ps.pytz
    ps.validators
    millify
  ]);

  runPy = pkgs.writeText "twitch-miner-run.py" ''
    import logging
    import pickle
    import requests

    _http_get = requests.get
    _played_segments = {}

    def _watch_segments(url, **kw):
        # shortcut: one request per new media segment each minute, Twitch only credits drops for channels whose segments are being pulled
        r = _http_get(url, **kw)
        if ".m3u8" not in url or r.status_code != 200 or "#EXT-X-STREAM-INF" not in r.text:
            return r
        variants = [l.strip() for l in r.text.split("\n") if l.strip().startswith("http")]
        if not variants:
            return r
        media = _http_get(variants[-1], headers=kw.get("headers"), timeout=20)
        segments = [l.strip() for l in media.text.split("\n") if l.strip().startswith("http")]
        seen = _played_segments.setdefault(url.split("?")[0], set())
        for segment in segments:
            if segment in seen:
                continue
            try:
                seg = _http_get(segment, headers=kw.get("headers"), timeout=20)
            except requests.exceptions.RequestException:
                continue
            if seg.status_code == 200:
                seen.add(segment)
        r._content = (r.text + "\n" + variants[-1] + "\n").encode()
        return r

    requests.get = _watch_segments

    from TwitchChannelPointsMiner import TwitchChannelPointsMiner
    from TwitchChannelPointsMiner.constants import CLIENT_ID, GQLOperations
    from TwitchChannelPointsMiner.logger import LoggerSettings
    from TwitchChannelPointsMiner.classes.Chat import ChatPresence
    from TwitchChannelPointsMiner.classes.Discord import Discord
    from TwitchChannelPointsMiner.classes.Settings import Priority, Events
    from TwitchChannelPointsMiner.classes.entities.Bet import (
        Strategy,
        BetSettings,
        Condition,
        OutcomeKeys,
        FilterCondition,
        DelayMode,
    )
    from TwitchChannelPointsMiner.classes.entities.Streamer import StreamerSettings

    with open("/run/agenix/twitch-discord-webhook") as f:
        discord_webhook = f.read().strip()

    GQL = GQLOperations.url
    ALLOWED_GAMES = ["Cyberpunk 2077", "Overwatch"]
    ALWAYS = ["DarkViperAU", "ow_esports"]

    def auth_header():
        with open("cookies/vmohammad24.pkl", "rb") as f:
            token = next(c["value"] for c in pickle.load(f) if c["name"] == "auth-token")
        return {"Client-ID": CLIENT_ID, "Authorization": f"OAuth {token}"}

    def in_progress_campaigns():
        query = "{currentUser{inventory{dropCampaignsInProgress{id name status endAt game{name}}}}}"
        try:
            r = requests.post(GQL, json={"query": query}, headers=auth_header(), timeout=30)
            e = (((r.json().get("data") or {}).get("currentUser") or {}).get("inventory") or {})
            return [c for c in (e.get("dropCampaignsInProgress") or []) if c.get("status") == "ACTIVE"]
        except Exception as e:
            print(f"campaign lookup failed: {e}", flush=True)
            return []

    def drop_channel(game, campaign_id, limit=20):
        query = '{game(name:"%s"){streams(first:%d){edges{node{broadcaster{id login}}}}}}' % (game, limit)
        r = requests.post(GQL, json={"query": query}, headers={"Client-ID": CLIENT_ID}, timeout=30)
        edges = (((r.json().get("data") or {}).get("game") or {}).get("streams") or {}).get("edges") or []
        auth = auth_header()
        for e in edges:
            b = e["node"]["broadcaster"]
            body = dict(GQLOperations.DropsHighlightService_AvailableDrops)
            body["variables"] = {"channelID": b["id"]}
            try:
                vc = (((requests.post(GQL, json=body, headers=auth, timeout=30).json().get("data") or {}).get("channel") or {}).get("viewerDropCampaigns")) or []
            except Exception:
                continue
            if any(c.get("id") == campaign_id for c in vc):
                return b["login"]
        return None

    streamers = list(ALWAYS)
    camps = [c for c in in_progress_campaigns() if (c.get("game") or {}).get("name") in ALLOWED_GAMES]
    print(f"in-progress campaigns: {[(c['name'], c['game']['name'], c['endAt']) for c in camps]}", flush=True)
    if camps:
        for camp in sorted(camps, key=lambda c: c["endAt"] or ""):
            login = drop_channel(camp["game"]["name"], camp["id"])
            if login and login.lower() not in [s.lower() for s in streamers]:
                streamers.append(login)
                print(f"farming: {camp['name']} via {login}", flush=True)
                break
            print(f"skipped: {camp['name']} - no participating live channel", flush=True)
    print(f"watching: {streamers}", flush=True)

    twitch_miner = TwitchChannelPointsMiner(
        username="vmohammad24",
        priority=[Priority.DROPS, Priority.STREAK, Priority.ORDER],
        enable_analytics=False,
        logger_settings=LoggerSettings(
            save=True,
            console_level=logging.INFO,
            console_username=False,
            auto_clear=True,
            time_zone="Asia/Amman",
            file_level=logging.INFO,
            emoji=True,
            less=False,
            colored=False,
            discord=Discord(
                webhook_api=discord_webhook,
                events=[
                    Events.STREAMER_ONLINE,
                    Events.STREAMER_OFFLINE,
                    Events.BET_LOSE,
                    Events.CHAT_MENTION,
                ],
            ),
        ),
        streamer_settings=StreamerSettings(
            make_predictions=True,
            follow_raid=True,
            claim_drops=True,
            claim_moments=True,
            watch_streak=True,
            community_goals=False,
            chat=ChatPresence.ONLINE,
            bet=BetSettings(
                strategy=Strategy.SMART,
                percentage=5,
                percentage_gap=20,
                max_points=50000,
                stealth_mode=True,
                delay_mode=DelayMode.FROM_END,
                delay=6,
                minimum_points=2000,
                filter_condition=FilterCondition(
                    by=OutcomeKeys.TOTAL_USERS,
                    where=Condition.LTE,
                    value=800,
                ),
            ),
        ),
    )

    def campaigns_from_inventory(self, status=None):
        inv = self._Twitch__get_inventory() or {}
        out = []
        for c in inv.get("dropCampaignsInProgress") or []:
            if status and (c.get("status") or "").upper() != status.upper():
                continue
            g = c.get("game") or {}
            c = dict(c)
            c["game"] = {
                "id": g.get("id"),
                "displayName": g.get("name"),
                "name": g.get("name"),
                "slug": g.get("slug"),
                "__typename": "Game",
            }
            out.append(c)
        return out

    TwitchCls = type(twitch_miner.twitch)
    TwitchCls._Twitch__get_drops_dashboard = campaigns_from_inventory
    TwitchCls._Twitch__get_campaigns_details = lambda self, campaigns: campaigns

    twitch_miner.mine(
        streamers,
    )
  '';
in {
  users.users.twitch-miner = {
    isSystemUser = true;
    group = "twitch-miner";
  };
  users.groups.twitch-miner = {};

  systemd.services.twitch-miner = {
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];
    environment.PYTHONPATH = "${src}";
    path = [python];
    serviceConfig = {
      User = "twitch-miner";
      Group = "twitch-miner";
      StateDirectory = "twitch-miner";
      WorkingDirectory = "/var/lib/twitch-miner";
      ExecStart = "${python}/bin/python3 ${runPy}";
      Restart = "always";
      RestartSec = 30;
      RuntimeMaxSec = "1h";
    };
  };
}
