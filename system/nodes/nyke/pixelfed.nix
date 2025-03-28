{
  pkgs,
  config,
  specialArgs,
  ...
}:
let
  inherit (specialArgs.vars.pixelfed) endpoint;
in
{
  services.pixelfed = {
    enable = true;
    inherit (endpoint) domain;
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
    secretFile = config.age.secrets.pixelfed.path;
    database.createLocally = true;
    redis.createLocally = true;
    phpPackage = pkgs.php83;

    nginx = {
      listen = [
        {
          inherit (endpoint) addr port;
        }
      ];
    };
  };
}
