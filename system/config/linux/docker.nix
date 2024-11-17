{ pkgs, ... }:
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

  # workaround for slirp4netns
  # See: https://github.com/NixOS/nixpkgs/issues/231191
  environment.etc."resolv.conf".mode = "direct-symlink";

  services.dockerRegistry = {
    enable = true;
    enableGarbageCollect = true;
    garbageCollectDates = "*-*-* 04:00:00";
  };

  systemd.services.docker-registry.serviceConfig.ExecStartPre = toString (
    pkgs.writeShellScript "wait.sh" ''
      while [[ -z "$(${pkgs.tailscale}/bin/tailscale ip | head -n1)" ]]; do
        sleep 1
      done
    ''
  );
}
