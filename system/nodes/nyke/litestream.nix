{ lib, config, ... }:
{
  # force set to service user as root
  # this is workaround for permission issue
  systemd.services.litestream.serviceConfig.User = lib.mkForce "root";
  systemd.services.litestream.serviceConfig.Group = lib.mkForce "root";
  services.litestream = {
    enable = true;
    # TODO: provide by agenix?
    environmentFile = "/etc/secrets/litestream/env";
    settings = {
      dbs = [
        {
          # for GoToSocial service
          path = config.services.gotosocial.settings.db-address;
          replicas = [
            {
              url = "\${GOTOSOCIAL_S3_URL}";
              endpoint = "\${GOTOSOCIAL_S3_ENDPOINT}";
              access-key-id = "\${GOTOSOCIAL_S3_ACCESS_KEY_ID}";
              secret-access-key = "\${GOTOSOCIAL_S3_SECRET_ACCESS_KEY}";
            }
          ];
        }
      ];
    };
  };
}
