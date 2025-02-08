{ pkgs, specialArgs, ... }:
let
  freshrss = specialArgs.vars.freshrss.endpoint;
  virtualHost = freshrss.domain;
  baseUrl = freshrss.https;
in
{
  services.freshrss = {
    enable = true;
    inherit virtualHost;
    database.type = "sqlite";
    inherit baseUrl;
    language = "ja";

    defaultUser = "kalaclista";
    passwordFile = "/etc/secrets/freshrss/kalaclista";

    extensions = with pkgs; [
      freshrss-flaresolverr-extension
    ];
  };

  services.nginx.virtualHosts."${virtualHost}".listen = [
    {
      inherit (freshrss) addr port;
    }
  ];
}
