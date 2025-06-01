final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: rec {
    version = "1.26.2";
    src = prev.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "FreshRSS";
      rev = version;
      hash = "sha256-TVtyX0/HKtLHFjHHjZDwOOcbHJ7Bq0NrlI3drlm6Gy4=";
    };

    postInstall = ''
      cp ${final.freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });

  pixelfed = prev.pixelfed.overrideAttrs (_: {
    version = "0.12.6-dev";
    src = prev.fetchFromGitHub {
      owner = "pixelfed";
      repo = "pixelfed";
      rev = "18d1c1a938c2d1ae23d3555269d5435648a0ec3a";
      hash = "sha256-sl1cxcq0eZuoI3hwAe8MtZ3o4hqBuu1EYBgA5hQ5cE4=";
    };

    vendorHash = "sha256-l3zG0t7XRpfCNi2HqsxtPlL5ZTbgzOlOqoaEQ4R1kG0=";
  });

  nyke-reboot = require ./nyke-reboot { };
}
