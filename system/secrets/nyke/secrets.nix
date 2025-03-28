let
  inherit ((import <nixpkgs> { }).pkgs) lib;

  publicKeys = [
    # nyke
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAke1FY9xveVjOr3uYaO/bxnQrRK9IEkwgn80vMfZpUo"
  ];

in
lib.attrsets.concatMapAttrs (k: _: {
  "${k}.age" = {
    inherit publicKeys;
  };
}) (import ./config.nix)
