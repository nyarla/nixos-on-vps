{ pkgs, config, ... }:
let
  location = "/etc/backup/mysql";
in
{
  services.mysqlBackup = {
    enable = true;
    calendar = "02:00:00";
    databases = config.services.mysql.ensureDatabases;
    inherit location;
  };

  systemd.services.mysql-backup.serviceConfig.ExecStartPost = pkgs.writeShellScript "upload.sh" ''
    export PATH=${pkgs.s5cmd}/bin:$PATH

    set -xeuo pipefail
    declare -r date=$(date +%Y-%m-%d)

    cd "${location}" && env $(cat ${config.age.secrets.mysql-backup.path}) s5cmd mv '*.gz' s3://kalaclista-backup-mysql/''${date}/

    exit 0
  '';
}
