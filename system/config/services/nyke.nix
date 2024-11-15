_: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "registry.nyke.server.thotep.net" = {
        listenAddresses = [ "100.72.114.65" ];
        useACMEHost = "nyke.server.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:5000
        '';
      };
      "reader.nyke.server.thotep.net" = {
        listenAddresses = [ "100.72.114.65" ];
        useACMEHost = "nyke.server.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 0.0.0.0:8080
        '';
      };
    };
  };
}
