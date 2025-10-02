{
  config,
  lib,
  pkgs,
  ...
}:
let
  checkHealth =
    {
      addr,
      port,
      domain,
      path,
    }:
    let
      agent = "Mozilla/5.0 (X11; Linux x86_64; rev:143.0) Gecko/20100101 Firefox/143.0";
    in
    pkgs.writeShellScript "check-headlth-${domain}" ''
      export PATH=${
        lib.makeBinPath (
          with pkgs;
          [
            curl
            coreutils
          ]
        )
      }:$PATH

      if [[ "$(curl -I -s -A '${agent}' -H '${domain}' 'http://${addr}:${toString port}${path}' | head -n1 | cut -d' ' -f2)" = 200 ]]; then
        echo "This service is lives: ${domain}"
        exit 0
      else
        echo "This service is dead: ${domain}"
        exit 2
      fi
    '';
  vars = import ./vars.nix;
in
{
  services.mackerel-agent = {
    enable = true;
    apiKeyFile = config.age.secrets.mackerel-agent.path;
    settings = {
      display_name = "Nyke";
      cloud_platform = "none";
      filesystems = {
        ignore = "/dev/vda[12]";
        use_mountpoint = false;
      };
      interfaces = {
        ignore = "ens[45]";
      };
      plugin = {
        checks = {
          gotosocial = {
            command = toString (checkHealth {
              inherit (vars.gotosocial.app) addr port domain;
              path = "/livez";
            });
          };

          pixelfed = {
            command = toString (checkHealth {
              inherit (vars.pixelfed.endpoint) addr port domain;
              path = "/api/service/health-check";
            });
          };

          searx = {
            command = toString (checkHealth {
              inherit (vars.searx.app) addr port domain;
              path = "/healthz";
            });
          };

          freshrss = {
            command = toString (checkHealth {
              inherit (vars.freshrss.endpoint) addr port domain;
              path = "/i/";
            });
          };
        };
      };
    };
  };

  systemd.services.mackerel-agent.serviceConfig = {
    User = "mackerel-agent";
    Group = "mackerel-agent";
    DynamicUser = lib.mkForce false;
  };
  users.users.mackerel-agent = {
    isSystemUser = true;
    group = "mackerel-agent";
  };
  users.groups.mackerel-agent = { };
}
