final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: rec {
    version = "1.27.0";
    src = prev.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "FreshRSS";
      rev = version;
      hash = "sha256-jz9MFWkZBjiBu6jr1jp+bDpthB/OWE0pfrXhY5B08Jo=";
    };

    postInstall = ''
      cp ${final.freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });

  pixelfed = prev.callPackage (
    {
      fetchFromGitHub,
      php,
      dataDir ? "/var/lib/pixelfed",
      runtimeDir ? "/run/pixelfed",
      ...
    }:
    php.buildComposerProject2 (finalAttrs: {
      pname = "pixelfed";
      version = "0.12.6-dev";
      src = fetchFromGitHub {
        owner = "pixelfed";
        repo = "pixelfed";
        rev = "fddfb6a7129393ea9ad9a6c49ba23db6798025ad";
        hash = "sha256-s44Iy3/25R8PcN62Ve2F4wwwvqf6DdkdoS280QzEZFk=";
      };

      vendorHash = "sha256-tcDWSsQXfuBZoCuWnN6+hPM9SjtbZVUUTOnvj//BfOA=";

      postInstall = ''
        chmod -R u+w $out/share
        mv "$out/share/php/${finalAttrs.pname}"/* $out
        rm -R $out/bootstrap/cache
        # Move static contents for the NixOS module to pick it up, if needed.
        mv $out/bootstrap $out/bootstrap-static
        mv $out/storage $out/storage-static
        ln -s ${dataDir}/.env $out/.env
        ln -s ${dataDir}/storage $out/
        ln -s ${dataDir}/storage/app/public $out/public/storage
        ln -s ${runtimeDir} $out/bootstrap
        chmod +x $out/artisan
      '';
    })
  ) { };

  nyke-reboot = require ./nyke-reboot { };
}
