final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: rec {
    version = "1.26.0";
    src = prev.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "FreshRSS";
      rev = version;
      hash = "sha256-J3YYx2enB8NHxgWUcJHStd5LkGRIB6dx3avbjhyIs3Q=";
    };

    postInstall = ''
      cp ${final.freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });

  pixelfed = (prev.pixelfed.override { php = prev.php83; }).overrideAttrs (_: {
    version = "0.12.4";
    src = prev.fetchFromGitHub {
      owner = "pixelfed";
      repo = "pixelfed";
      rev = "65dd601a02f5840c9d3e25bb30cfbbd8d033d8ae";
      hash = "sha256-HEo0BOC/AEWhCApibxo2TBQF4kbLrbPEXqDygVQlVic=";
    };

    vendorHash = "sha256-QkkSnQb9haH8SiXyLSS58VXSD4op7Hr4Z6vUAAYLIic=";
  });

  nyke-reboot = require ./nyke-reboot { };
}
