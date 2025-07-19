final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: rec {
    version = "1.26.3";
    src = prev.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "FreshRSS";
      rev = version;
      hash = "sha256-/573UMMALfU46uJefxf/DMhEcIMiI+CVR9lg9kXFdF0=";
    };

    postInstall = ''
      cp ${final.freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });

  pixelfed = prev.pixelfed.overrideDerivation (_: {
    version = "0.12.6-dev";
    src = prev.fetchFromGitHub {
      owner = "pixelfed";
      repo = "pixelfed";
      rev = "c9808358ed2398fa645bf502997e12c6470eeb80";
      hash = "sha256-DjaExQu9vM2aa60Iun/Gr1ynSQ121wg7Op0LTOWVJlA=";
    };
  });

  nyke-reboot = require ./nyke-reboot { };
}
