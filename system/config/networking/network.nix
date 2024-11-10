_:
let
  json = builtins.fromJSON (builtins.readFile /etc/nixos/.config.json);
in
{
  inherit (json) networking;
}
