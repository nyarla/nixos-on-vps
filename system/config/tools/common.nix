{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim
    lsof
    htop
  ];
}
