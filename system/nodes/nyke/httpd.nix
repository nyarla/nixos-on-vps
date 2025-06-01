{
  pkgs,
  config,
  specialArgs,
  ...
}:
let
  waitForTailscaleIP = ''
    while [[ -z "$(${pkgs.tailscale}/bin/tailscale ip | head -n1)" ]]; do
      sleep 1
    done
  '';
in

{
  systemd.services.nginx.preStart = ''
    ${waitForTailscaleIP}
  '';
  systemd.services.caddy.serviceConfig.ExecStartPre = toString (
    pkgs.writeShellScript "preStart.sh" ''
      ${waitForTailscaleIP}
    ''
  );

  services.caddy = {
    enable = true;
    #package = pkgs.caddy-with-plugins;
    globalConfig = ''
      auto_https off

      servers {
        trusted_proxies static 127.0.0.1/32
        client_ip_headers Cf-Connecting-Ip X-Forwarded-For
      }
    '';
    virtualHosts =
      let
        inherit (specialArgs) vars;
        inherit (vars) listen;

        # Public services
        # ===============

        # GoToSocial
        # ----------
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

        # Private services
        # ================

        # Search
        # ------
        searx =
          listen {
            domain = "${vars.searx.app.domain}";
            addr = config.services.searx.settings.server.bind_address;
            inherit (config.services.searx.settings.server) port;
          }
          // {
            inherit (vars.searx) endpoint;
          };

        # RSS Reader
        # ----------
        freshrss =
          let
            inherit (config.services.freshrss) virtualHost;
            inherit (builtins.elemAt config.services.nginx.virtualHosts."${virtualHost}".listen 0) addr port;
          in
          listen {
            domain = virtualHost;
            inherit addr;
            inherit port;
          }
          // {
            inherit (vars.freshrss) endpoint;
          };

        # Common settings
        # ===============

        # Let's encrypt certificate
        useACMEHost = "nyke.server.thotep.net";

        # TODO: persistent logs
        logFormat = ''
          output stdout
        '';
      in
      {
        # Public services
        # ===============

        # GoToSocial
        "${gotosocial.endpoint.http}:${toString gotosocial.endpoint.port}" = {
          listenAddresses = [ gotosocial.endpoint.addr ];
          inherit logFormat;
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

        # Private services
        # ================
        "${searx.endpoint.domain}" = {
          listenAddresses = [ searx.endpoint.addr ];
          inherit useACMEHost;
          inherit logFormat;
          extraConfig = ''
            reverse_proxy ${searx.listen}
          '';
        };

        "${freshrss.endpoint.domain}" = {
          listenAddresses = [ freshrss.endpoint.addr ];
          inherit useACMEHost;
          inherit logFormat;
          extraConfig = ''
            reverse_proxy ${freshrss.listen}
          '';
        };
      };
  };
}
