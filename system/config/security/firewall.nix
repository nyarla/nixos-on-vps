{ pkgs, ... }:
{
  networking.firewall = {
    enable = true;
    allowPing = false;
  };

  environment.systemPackages = with pkgs; [ iproute2 ];
}
