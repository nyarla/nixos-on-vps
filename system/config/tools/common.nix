{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    lsof
    htop
  ];
}
