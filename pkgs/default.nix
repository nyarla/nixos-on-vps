final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };
}
