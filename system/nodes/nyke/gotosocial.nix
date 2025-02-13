{ specialArgs, ... }:
let
  inherit (specialArgs.vars.gotosocial) app;
in
{
  services.gotosocial = {
    enable = true;
    settings = {

      # general
      log-timestamp-format = "2006-01-02T15:04:05Z07:00";

      application-name = "カラクリスタ？";
      landing-page-user = "nyarla";

      host = app.domain;
      account-domain = app.domain;

      bind-address = app.addr;
      inherit (app) port;

      trusted-proxies = [
        "127.0.0.1/32"
        "::1"
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
    # TODO: provide by agenix?
    environmentFile = "/etc/secrets/gotosocial/env";
  };
}
