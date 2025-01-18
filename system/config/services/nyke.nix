{ config, lib, ... }:
{
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
