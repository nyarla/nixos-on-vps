{
  pkgs,
  config,
  specialArgs,
  ...
}:
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
    passwordFile = config.age.secrets.freshrss.path;

    extensions = with pkgs; [
      freshrss-flaresolverr-extension
    ];
  };

  services.nginx.virtualHosts."${virtualHost}".listen = [
    {
      inherit (freshrss) addr port;
    }
  ];

  systemd.services.freshrss-updater.serviceConfig.CPUQuota = "50%";
}
