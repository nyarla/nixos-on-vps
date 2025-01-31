{ writeShellScriptBin }:
writeShellScriptBin "reboot-nyke" ''
  stop() {
    sudo systemctl stop $@
  }

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
