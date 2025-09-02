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
      version = "0.12.6-dev"; # 2025-09-02
      src = fetchFromGitHub {
        owner = "pixelfed";
        repo = "pixelfed";
        rev = "e2fc2ceee8343b0a6dfb006234f9e8ffa0327e9e";
        hash = "sha256-j7hO4yTYZK6bKLgKYoJDJOiVPelup1hbvioOkTLRUZE=";
      };

      vendorHash = "sha256-9kqkqqsMEvipYKLgNNAd7YsbYihbQ6fukKZgtyGAddA=";

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
