{ pkgs, ... }:
let
  unstable = pkgs;
in
_: prev: {
  freshrss = unstable.freshrss.overrideAttrs (_: {
    postInstall = ''
      cp ${prev.freshrss-flaresolverr-extension}/share/freshrss/extensions/xExtension-FlareSolverr/cloudsolver.php $out/p/api/
    '';
  });

  inherit (unstable) open-webui searxng;
}
