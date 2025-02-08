{ pkgs, config, ... }:
{
  systemd.services.caddy.serviceConfig.ExecStartPre = toString (
    pkgs.writeShellScript "wait.sh" ''
      while [[ -z "$(${pkgs.tailscale}/bin/tailscale ip | head -n1)" ]]; do
        sleep 1
      done
    ''
  );

  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';
    virtualHosts =
      let
        freshrss =
          let
            hostname = config.services.freshrss.virtualHost;
            listen = builtins.elemAt config.services.nginx.virtualHosts."${hostname}".listen 0;
          in
          rec {
            inherit hostname;
            inherit (listen) addr port;
            address = "${addr}:${toString port}";
          };

        gotosocial = with config.services.gotosocial; rec {
          hostname = settings.host;
          addr = settings.bind-address;
          inherit (settings) port;
          address = "${addr}:${toString port}";
        };

        searx = rec {
          hostname = "search.nyke.server.thotep.net";
          addr = config.services.searx.settings.server.bind_address;
          inherit (config.services.searx.settings.server) port;
          address = "${addr}:${toString port}";
        };

        open-webui = rec {
          hostname = "chat.nyke.server.thotep.net";
          addr = config.services.open-webui.host;
          inherit (config.services.open-webui) port;
          address = "${addr}:${toString port}";
        };
      in
      {
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
        "${freshrss.hostname}" = {
          listenAddresses = [ "100.72.114.65" ];
          useACMEHost = "nyke.server.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy ${freshrss.address}
          '';
        };

        "${searx.hostname}" = {
          listenAddresses = [ "100.72.114.65" ];
          useACMEHost = "nyke.server.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy ${searx.address}
          '';
        };

        "${open-webui.hostname}" = {
          listenAddresses = [ "100.72.114.65" ];
          useACMEHost = "nyke.server.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy ${open-webui.address}
          '';
        };

        "albyhub.nyke.server.thotep.net" = {
          listenAddresses = [ "100.72.114.65" ];
          useACMEHost = "nyke.server.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy 127.0.0.1:12080
          '';
        };

        # GoToSocial
        "http://${gotosocial.hostname}:9080" = {
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

            reverse_proxy ${gotosocial.address}
          '';
        };
      };
  };
}
