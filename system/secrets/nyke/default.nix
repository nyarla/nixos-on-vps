{ lib, ... }:
{
  age.identityPaths = [
    "/var/lib/secrets/id_ed25519"
  ];

  age.secrets =
    let
      make =
        settings:
        lib.attrsets.concatMapAttrs (name: values: {
          "${name}" = {
            file = ./. + "/${name}.age";
          } // values;
        }) settings;

      config = import ./config.nix;
    in
    make config;
}
