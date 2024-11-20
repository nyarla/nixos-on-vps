_: {
  services.mackerel-agent = {
    enable = true;
    apiKeyFile = "/var/lib/mackerel-agent/apikey";
    settings = {
      display_name = "Nyke";
      cloud_platform = "none";
      filesystems = {
        ignore = "/dev/vda[12]";
        use_mountpoint = false;
      };
      interfaces = {
        ignore = "ens[45]";
      };
    };
  };

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
      "albyhub.nyke.server.thotep.net" = {
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
