{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
let
  nix = (pkgs.nixVersions.git.override { enableDocumentation = false; }).overrideAttrs (old: {
    pname = "nix";
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "12aff40ad7f2f71a4505152ec4f62bfadc0155cd";
      hash = "sha256-c9x5QBgNAd2buf7XXim3Q2NZWS+yr0DkcqmKC1/Mq+w=";
    };

    outputs = [
      "dev"
      "out"
    ];

    dontUseCmakeConfigure = true;

    buildInputs =
      old.buildInputs
      ++ (with pkgs; [
        boost
        lsof
        toml11
      ]);

    nativeBuildInputs =
      old.buildInputs
      ++ (with pkgs; [
        bison
        cmake
        flex
        meson
        ninja
        perl
        perlPackages.DBDSQLite
        perlPackages.DBI
        perlPackages.Test2Harness
        pkg-config
      ]);
  });
in
buildEnv {
  name = "nixos-on-vps";
  paths = [
    nix
  ];
  pathsToLink = [ "/bin" ];
}
