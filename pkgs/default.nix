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
      rev = "aba85566f26939a3c3045548153dcbaa66ac01be";
      hash = "sha256-7Wm3ykUwlCuZe3JDLpQfxwYAIub/f6hc4LQfbNeD13w=";
    };

    vendorHash = "sha256-eyIHvLGQrkJUs/BUINaJTnr1eatGGZBYeq5ioJAUaEk=";
  });

  nyke-reboot = require ./nyke-reboot { };
}
