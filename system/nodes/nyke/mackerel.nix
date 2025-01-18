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
}
