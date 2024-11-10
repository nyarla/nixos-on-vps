{ pkgs, ... }:
{
  imports = [
    ../config/datetime/jp.nix
    ../config/hardware/sakura.nix
    ../config/linux/docker.nix
    ../config/linux/optimize.nix
    ../config/networking/tailscale.nix
    ../config/networking/network.nix
    ../config/nixos/nixpkgs.nix
    ../config/security/firewall.nix
    ../config/tools/common.nix
    ../config/users/console.nix
  ];

  # hostname
  networking.hostName = "nyke";

  # filesystem and devices
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EC4D-6D8D";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/668e33b5-4176-4a20-8df6-c7ec5fce073d";
    fsType = "ext4";
    neededForBoot = true;
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/1ebc4520-f1aa-45ec-8db3-b10df3f4601d"; } ];

  # impersistence
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/etc/ssh"

      "/home/docker/.local/share/docker"

      "/nix"

      "/var/db"
      "/var/lib"
      "/var/log"

      "/tmp"
    ];
    files = [ "/etc/machine-id" ];
  };
}
