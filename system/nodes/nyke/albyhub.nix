{ specialArgs, ... }:
let
  inherit (specialArgs.vars.albyhub.endpoint) addr port;
  listen = "${addr}:${toString port}";
in
{
  virtualisation.oci-containers.containers."albyhub" = {
    autoStart = true;
    image = "ghcr.io/getalby/hub:v1.13.0";
    ports = [
      "${listen}:8080"
    ];
    environment = {
      DATABASE_URI = "/data/nwc.db";
      WORK_DIR = "/data";
      LOG_EVENTS = "true";
      AUTO_LINK_ALBY_ACCOUNT = "false";
    };
    volumes = [
      "/var/lib/albyhub/data:/data"
    ];
  };
}
