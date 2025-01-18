{ config, lib, ... }:
{
  services.gotosocial = {
    enable = true;
    settings = {

      # general
      log-timestamp-format = "2006-01-02T15:04:05Z07:00";

      application-name = "カラクリスタ？";
      landing-page-user = "nyarla";

      host = "kalaclista.com";
      account-domain = "kalaclista.com";

      bind-address = "127.0.0.1";
      port = 10080;

      trusted-proxies = [
        "127.0.0.1"
      ];

      # db
      db-type = "sqlite";
      db-address = "/var/lib/gotosocial/sqlite3.db";
      db-sqlite-journal-mode = "WAL";
      db-sqlite-synchronous = "NORMAL";
      cache.memory-target = "50MiB";

      # instance
      instance-languages = [ "ja" ];
      instance-federation-spam-filter = true;

      # accounts
      accounts-registration-open = false;
      accounts-allow-custom-css = true;

      # media
      media-emoji-remote-max-size = "200KiB";
      media-remote-cache-days = 7;

      # storage

      storage-backend = "s3";
      storage-s3-proxy = false;
      storage-s3-redirect-url = "https://gts.files.kalaclista.com";

      # useragent
      http-client = {
        timeout = "5s";
      };

      # advanced
      advanced-throttling-multiplier = 4;
      advanced-csp-extra-uris = [
        "gts.files.kalaclista.com"
      ];

      # kalaclista
      kalaclista-allowed-unauthorized-get = true;
      kalaclista-keep-emojis-forever = true;

    };
    environmentFile = "/etc/secrets/gotosocial/env";
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';
    virtualHosts = {
      "registry.nyke.server.thotep.net" = {
        listenAddresses = [ "100.72.114.65" ];
        useACMEHost = "nyke.server.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:5000
        '';
      };
      "reader.nyke.server.thotep.net" = {
        listenAddresses = [ "100.72.114.65" ];
        useACMEHost = "nyke.server.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 0.0.0.0:8080
        '';
      };
      "albyhub.nyke.server.thotep.net" = {
        listenAddresses = [ "100.72.114.65" ];
        useACMEHost = "nyke.server.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 0.0.0.0:8080
        '';
      };

      "http://kalaclista.com:9080" = {
        listenAddresses = [ "127.0.0.1" ];
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          root * /var/lib/www/kalaclista.com

          @exists file
          handle @exists {
            header /.well-known/nostr.json Access-Control-Allow-Origin "*"
            file_server
          }

          reverse_proxy 127.0.0.1:10080
        '';
      };
    };
  };
}
