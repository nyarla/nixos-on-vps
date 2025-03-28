{ pkgs, lib, ... }:
{
  imports = [
    ../config/datetime/jp.nix
    ../config/hardware/sakura.nix
    ../config/linux/optimize.nix
    ../config/networking/tailscale.nix
    ../config/nixos/nixpkgs.nix
    ../config/security/firewall.nix
    ../config/tools/common.nix
    ../config/users/console.nix

    ../nodes/nyke/albyhub.nix
    ../nodes/nyke/chat.nix
    ../nodes/nyke/freshrss.nix
    ../nodes/nyke/gotosocial.nix
    ../nodes/nyke/httpd.nix
    ../nodes/nyke/litestream.nix
    ../nodes/nyke/mackerel.nix
    ../nodes/nyke/pixelfed.nix

    ../nodes/nyke/backup.nix
  ];

  # hostname
  networking.hostName = "nyke";

  # filesystem and devices
  fileSystems =
    let
      device = "/dev/disk/by-uuid/128e7466-aa6d-49d5-a79d-3cbcdd6ef836";
      btrfsOptions = [
        "compress=zstd"
        "ssd"
        "space_cache=v2"
      ];
      btrfsNoExec = btrfsOptions ++ [
        "noexec"
        "nosuid"
        "nodev"
      ];

      subVol = options: path: {
        "/persist/${path}" = {
          inherit device;
          fsType = "btrfs";
          options = options ++ [ "subvol=/persist/${path}" ];
          neededForBoot = true;
        };
      };

      subVolsRW = paths: lib.mergeAttrsList (lib.lists.forEach paths (subVol btrfsNoExec));
      subVolsEx = paths: lib.mergeAttrsList (lib.lists.forEach paths (subVol btrfsOptions));
    in
    {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=256M"
          "noexec"
          "mode=0755"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/EC4D-6D8D";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
        neededForBoot = true;
      };

      "/nix" = {
        inherit device;
        fsType = "btrfs";
        options = btrfsOptions ++ [ "subvol=/nix" ];
        neededForBoot = true;
      };

      "/tmp" = {
        inherit device;
        fsType = "btrfs";
        options = btrfsOptions ++ [ "subvol=/tmp" ];
        neededForBoot = true;
      };
    }
    // (subVolsRW [
      "etc"
      "root"

      "var/db"
      "var/log"
      "var/lib"
    ]);

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "Sat *-*-* 23:00:00";
  services.btrfs.autoScrub.fileSystems = [
    "/nix"
    "/tmp"

    "/persist/etc"
    "/persist/root"

    "/persist/var/db"
    "/persist/var/lib"
    "/persist/var/log"
  ];

  services.snapper.snapshotInterval = "*-*-* 04:00:00";
  services.snapper.cleanupInterval = "*-*-1 00:00:00";
  services.snapper.configs =
    let
      snapshot = path: {
        "${builtins.replaceStrings [ "/" ] [ "-" ] path}" = {
          SUBVOLUME = builtins.toPath "/persist/${path}";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMETINE_MIN_AGE = 1800;
          TIMELINE_LIMIT_HOURLY = 6;
          TIMELIME_DAILY = 7;
          TIMELINE_WEEKLY = 2;
          TIMELINE_MONTHLY = 1;
          TIMELINE_YEARLY = 1;
        };
      };

      snapshots = paths: lib.attrsets.mergeAttrsList (lib.lists.forEach paths snapshot);
    in
    snapshots [
      "var/lib"
    ];

  swapDevices = [ { device = "/dev/disk/by-uuid/1ebc4520-f1aa-45ec-8db3-b10df3f4601d"; } ];

  # impersistence
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/ssh"
      "/etc/secrets"
      "/etc/backup"

      "/var/db"
      "/var/lib"
      "/var/log"

      "/root"
    ];
    files = [ "/etc/machine-id" ];
  };

  environment.systemPackages = with pkgs; [
    nyke-reboot
  ];
}
