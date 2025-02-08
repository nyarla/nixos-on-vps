{ writeShellScriptBin }:
writeShellScriptBin "nyke-reboot" ''
  stop() {
    sudo systemctl stop $@
  }

  if [[ "$(hostname)" != "nyke" ]]; then
    echo 'This machine is not `nyke`.' >&2;
    exit 1
  fi

  sudo echo 'Reboot system'

  set -x

  # endpoint http server
  stop caddy.service
  stop nginx.service

  # gotosocial
  stop gotosocial.service
  stop litestream.service

  # albyhub
  stop podman-albyhub

  # freshrss
  stop freshrss-updater.timer
  stop freshrss-updater.service
  stop phpfpm-freshrss.service

  # pixelfed
  stop phpfpm-pixelfed.service
  stop pixelfed-cron.timer
  stop pixelfed-horizon.service
  stop redis-pixelfed.service

  # reboot system
  sudo systemctl reboot
''
