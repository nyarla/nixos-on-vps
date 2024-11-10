{
  pkgs,
  ...
}:
let
  json = builtins.fromJSON (builtins.readFile ../../../../../../boot/config.json) ;
in
{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      ip = "127.0.0.1";
    };
  };

  users.users.docker = {
    isNormalUser = true;
  };

  services.dockerRegistry = {
    enable = true;
    enableGarbageCollect = true;
    garbageCollectDates = "*-*-* 04:00:00";
    inherit (json.services.dockerRegistry) listenAddress;
  };

  systemd.services.docker-registry.serviceConfig.ExecStartPre = toString (pkgs.writeShellScript "wait.sh" ''
    while [[ -z "$(${pkgs.tailscale}/bin/tailscale ip | head -n1)" ]]; do
      sleep 1
    done
  '');
}
