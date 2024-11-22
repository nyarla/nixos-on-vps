_: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
      "--accept-dns=false"
    ];
    openFirewall = true;
  };

  # environment.etc."resolv.conf".mode = "direct-symlink";
}
