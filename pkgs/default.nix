final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: {
    postInstall = ''
      cp ${freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });
}
