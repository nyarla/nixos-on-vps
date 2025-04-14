{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
let
  nix = nixVersions.git;
in
buildEnv {
  name = "nixos-on-vps";
  paths = [
    nix
  ];
  pathsToLink = [ "/bin" ];
}
