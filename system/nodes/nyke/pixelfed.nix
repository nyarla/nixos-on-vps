{ pkgs, ... }:
{
  services.pixelfed = {
    enable = true;
    domain = "px.kalaclista.com";
    settings = {
      # Permanentally disabled
      OPEN_REGISTRATION = false;
      ENFORCE_EMAIL_VERIFICATION = true;

      # Temporary disabled
      ACTIVITY_PUB = false;
      OAUTH_ENABLED = false;

      # Instance configurations
      APP_NAME = "kalaclista.px";
      APP_LOCALE = "ja";

      INSTANCE_DESCRIPTION = "「輝かしい青春」なんて失かった人の思い出。画像が投稿される";
      INSTANCE_CONTACT_EMAIL = "nyarla@kalaclista.com";

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
