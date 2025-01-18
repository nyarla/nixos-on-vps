_: {
  virtualisation.oci-containers.containers."albyhub" = {
    autoStart = true;
    image = "ghcr.io/getalby/hub:v1.12.0";
    ports = [
      "127.0.0.1:12080:8080"
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
