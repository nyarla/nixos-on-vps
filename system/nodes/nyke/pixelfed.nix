{ pkgs, ... }:
{
  services.pixelfed = {
    enable = true;
    domain = "px.kalaclista.com";
    settings = {
      # Permanentally disabled
      OPEN_REGISTRATION = false;
      ENFORCE_EMAIL_VERIFICATION = true;

      # Instance configurations
      APP_NAME = "kalaclista.px";
      APP_LOCALE = "ja";

      ACTIVITY_PUB = true;
      OAUTH_ENABLED = true;

      PF_LOCAL_AVATAR_TO_CLOUD = true;
    };
    secretFile = "/etc/secrets/pixelfed/env";
    database.createLocally = true;
    redis.createLocally = true;
    phpPackage = pkgs.php83;

    nginx = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 13080;
        }
      ];
    };
  };
}
