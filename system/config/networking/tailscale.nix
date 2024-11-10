_: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];
    openFirewall = true;
  };
}
