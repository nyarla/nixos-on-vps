final: prev:
let
  require = path: prev.callPackage (import path);
in
rec {
  freshrss-flaresolverr-extension = require ./freshrss-flaresolverr-extension { };
  gotosocial = require ./gotosocial { };
  litestream = require ./litestream { };

  freshrss = prev.freshrss.overrideAttrs (_: rec {
    version = "1.27.1";
    src = prev.fetchFromGitHub {
      owner = "FreshRSS";
      repo = "FreshRSS";
      rev = version;
      hash = "sha256-EpszwgYzobRA7LohtJJtgTefFAEmCXvcP3ilfsu+obo=";
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
      version = "0.12.6";
      src = fetchFromGitHub {
        owner = "pixelfed";
        repo = "pixelfed";
        rev = "f5f7b3e6784ef2d1091c39dcb795ed8618fb0775";
        hash = "sha256-FxJWoFNyIGQ6o9g2Q0/jaBMyeH8UnbTgha2goHAurvY=";
      };

      vendorHash = "sha256-ciHP6dE42pXupZl4V37RWcHkIZ+xf6cnpwqd3C1dNmQ=";

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
