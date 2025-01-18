final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };
}
