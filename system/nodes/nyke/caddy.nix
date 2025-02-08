{
  pkgs,
  config,
  specialArgs,
  ...
}:
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
        inherit (specialArgs) vars;
        inherit (vars) listen;

        gotosocial =
          (
            with config.services.gotosocial;
            listen {
              domain = settings.host;
              addr = settings.bind-address;
              inherit (settings) port;
            }
          )
          // {
            inherit (vars.gotosocial) endpoint;
          };

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

        searx =
          listen {
            domain = "${vars.searx.app.domain}";
            addr = config.services.searx.settings.server.bind_address;
            inherit (config.services.searx.settings.server) port;
          }
          // {
            inherit (vars.searx) endpoint;
          };

        open-webui =
          listen {
            inherit (vars.open-webui.endpoint) domain;
            addr = config.services.open-webui.host;
            inherit (config.services.open-webui) port;
          }
          // {
            inherit (vars.open-webui) endpoint;
          };
      in
      {
        # Public services
        # ===============

        # GoToSocial
        "${gotosocial.endpoint.http}:${toString gotosocial.endpoint.port}" = {
          listenAddresses = [ gotosocial.endpoint.addr ];
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

            reverse_proxy ${gotosocial.listen}
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

        # Private services
        # ================
        "${searx.endpoint.domain}" = {
          listenAddresses = [ searx.endpoint.addr ];
          useACMEHost = "nyke.server.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy ${searx.listen}
          '';
        };

        "${open-webui.endpoint.domain}" = {
          listenAddresses = [ open-webui.endpoint.addr ];
          useACMEHost = "nyke.server.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy ${open-webui.listen}
          '';
        };
      };
  };
}
