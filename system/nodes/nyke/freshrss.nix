{ config, ... }:
let
  virtualHost = "reader.nyke.server.thotep.net";
in
{
  services.freshrss = {
    enable = true;
    inherit virtualHost;
    database.type = "sqlite";
    baseUrl = "https://reader.nyke.server.thotep.net";
    language = "ja";

    defaultUser = "kalaclista";
    passwordFile = "/etc/secrets/freshrss/kalaclista";
  };

  services.nginx.virtualHosts."${virtualHost}".listen = [
    {
      addr = "127.0.0.1";
      port = 11080;
    }
  ];
}
