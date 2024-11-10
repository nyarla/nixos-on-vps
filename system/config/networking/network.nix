_:
let
  json = builtins.fromJSON (builtins.readFile ../../../../../../boot/config.json);
in
{
  inherit (json) networking;
}
