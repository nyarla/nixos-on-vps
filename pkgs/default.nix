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
        rev = "5921c51db990ffa57e4afc52440290dd5afb9b96";
        hash = "sha256-h4AkaFhFlQ7Dc4R6tRJtN3reBXWEwWogNpe7hmVEgNg=";
      };

      vendorHash = "sha256-qMRkJAbVG7Gbyqy3dFfwwFqSA5t8GDFnV0WucJIMxDs=";

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
