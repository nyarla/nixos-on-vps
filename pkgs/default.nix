final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: rec {
    version = "1.26.1";
    src = prev.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "FreshRSS";
      rev = version;
      hash = "sha256-hgkFNZg+A1cF+xh17d2n4SCvxTZm/Eryj6jP7MvnpTE=";
    };

    postInstall = ''
      cp ${final.freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });

  pixelfed = prev.pixelfed.overrideAttrs (_: {
    version = "0.12.5";
    src = prev.fetchFromGitHub {
      owner = "pixelfed";
      repo = "pixelfed";
      rev = "9e34cfe9df56b24c64925de90a208ceacfc07ce0";
      hash = "sha256-bPoYEPCWj7vAKDL/P4yjhrfp4HK9sbBh4eK0Co+xaZc=";
    };

    vendorHash = "sha256-/ep0j1KUBrpcJsd40L8PbUHSrIhV1bKRkq+qqbJB2sM=";
  });

  nyke-reboot = require ./nyke-reboot { };
}
