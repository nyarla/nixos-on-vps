_:
let
  json = builtins.fromJSON (builtins.readFile /etc/nixos/.config.json);
in
{
  users.users.console = (
    {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    }
    // json.users.users.console
  );
}
