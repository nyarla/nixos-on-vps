{ writeShellScriptBin, symlinkJoin }:
let
  stopService = ''
    stop() {
      sudo systemctl stop $@
    }

    # metric service
    stop mackerel-agent.service

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
  '';

  nyke-reboot = writeShellScriptBin "nyke-reboot" ''
    if [[ "$(hostname)" != "nyke" ]]; then
      echo 'This machine is not `nyke`.' >&2;
      exit 1
    fi

    sudo echo 'Reboot system'

    ${stopService}

    sudo systemctl reboot
  '';

  nyke-shutdown = writeShellScriptBin "nyke-shutdown" ''
    if [[ "$(hostname)" != "nyke" ]]; then
      echo 'This machine is not `nyke`.' >&2;
      exit 1
    fi

    sudo echo 'Shutdown system'

    ${stopService}

    sudo shutdown -h now
  '';
in
symlinkJoin {
  name = "nyke-reboot";
  paths = [
    nyke-reboot
    nyke-shutdown
  ];
}
