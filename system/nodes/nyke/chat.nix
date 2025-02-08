{ pkgs, lib, ... }:
{
  # Open Web UI
  services.open-webui = {
    enable = true;
    port = 14080;
    environmentFile = "/etc/secrets/open-webui/env";
  };

  # Searxng
  systemd.services.searx.serviceConfig.ExecStartPre = pkgs.writeShellScript "searx-prestart" ''
    cd /run/searx && ln -sf /etc/searxng/limiter.toml limiter.toml
  '';
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = "/etc/secrets/searxng/env";
    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 48;
      };

      botdetection.ip_lists = {
        pass_ip = [
          "100.60.0.0/10"
        ];
      };
    };

    settings = {
      use_default_settings = {
        engines.keep_only = [ ];
      };

      ui = {
        default_locale = "ja";
      };

      server = {
        base_url = "https://search.nyke.server.thotep.net";
        port = 15080;
        bind_address = "127.0.0.1";
        limiter = false;
      };

      search = {
        safe_search = 0;
        autocomplete = "duckduckgo";
        favicon_resolver = "google";
        default_lang = "auto";
        languages = [
          "all"
          "ja"
          "en-US"
        ];
        formats = [
          "html"
          "csv"
          "json"
          "rss"
        ];
      };

      categories_as_tabs = {
        # default categories
        dev = { };
        general = { };
        images = { };
        videos = { };
        website = { };
      };

      engines =
        let
          toEngine = tab: engine: engine // { categories = [ tab ]; };
          define =
            tabs:
            lib.flatten (
              lib.attrsets.mapAttrsToList (_: engine: engine) (
                lib.attrsets.mapAttrs (tab: engines: (lib.forEach engines (engine: toEngine tab engine))) tabs
              )
            );
        in
        define {
          # default categories
          general = [
            {
              name = "duckduckgo";
              engine = "duckduckgo";
              shortcut = "duck";
            }
            {
              name = "google";
              engine = "google";
              shortcut = "google";
            }
          ];

          images = [
            {
              name = "google images";
              engine = "google_images";
              shortcut = "images";
            }
          ];

          videos = [
            {
              name = "youtube";
              engine = "youtube_noapi";
              shortcut = "tube";
            }
            {
              name = "niconico";
              engine = "xpath";
              shortcut = "nico";

              paging = true;
              template = "video.html";

              search_url = ''https://www.nicovideo.jp/search/{query}?page={pageno}&sort=n&order=d'';

              url_xpath = ''//li[@data-video-id]//p[@class="itemTitle"]/a/@href'';
              title_xpath = ''//li[@data-video-id]//p[@class="itemTitle"]/a'';
              content_xpath = ''//li[@data-video-id]//p[@class="itemDescription"]'';
              thumbnail_xpath = ''//li[@data-video-id]//img[@class="thumb"]/@src'';
              suggestion_xpath = ''//div[@class="tagListBox"]/ul[@class="tags"]//li[@class="item"]'';
            }
          ];

          # custom categories
          apps = [
            {
              name = "fdroid";
              engine = "fdroid";
              shortcut = "fdroid";
            }
            {
              name = "google play store";
              engine = "google_play";
              shortcut = "playapp";
              play_categ = "apps";
            }
          ];

          dev = [
            {
              name = "github";
              engine = "github";
              shortcut = "github";
            }
            {
              name = "metacpan";
              engine = "metacpan";
              shortcut = "cpan";
              disabled = false;
            }
            {
              name = "npm";
              engine = "npm";
              shortcut = "npm";
            }
          ];

          website = [
            {
              name = "the.kalaclista.com";
              engine = "xpath";
              shortcut = "blog";

              search_url = "https://the.kalaclista.com/search?q={query}";
              url_xpath = ''//a[@class="entry-title-link"]/@href'';
              title_xpath = ''//a[@class="entry-title-link"]'';
              content_xpath = ''//div[@class="archive-entry-body"]'';
              no_result_for_http_status = [ 404 ];
            }
            {
              name = "let.kalaclista.com";
              engine = "xpath";
              shortcut = "essay";

              search_url = "https://let.kalaclista.com/search?q={query}";
              url_xpath = ''//a[@class="entry-title-link"]/@href'';
              title_xpath = ''//a[@class="entry-title-link"]'';
              content_xpath = ''//div[@class="archive-entry-body"]'';
              no_result_for_http_status = [ 404 ];
            }
          ];

        };
    };
  };
}
