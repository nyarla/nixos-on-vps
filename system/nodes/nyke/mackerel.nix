{ config, lib, ... }:
{
  services.mackerel-agent = {
    enable = true;
    apiKeyFile = config.age.secrets.mackerel-agent.path;
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

  systemd.services.mackerel-agent.serviceConfig = {
    User = "mackerel-agent";
    Group = "mackerel-agent";
    DynamicUser = lib.mkForce false;
  };
  users.users.mackerel-agent = {
    isSystemUser = true;
    group = "mackerel-agent";
  };
  users.groups.mackerel-agent = { };
}
