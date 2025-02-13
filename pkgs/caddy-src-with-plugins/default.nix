{
  lib,
  stdenvNoCC,
  caddy,
  git,
  go,
  xcaddy,
  cacert,

  plugins ? [ ],
  outputHash ? lib.fakeHash,
}:
stdenvNoCC.mkDerivation rec {
  pname = "caddy-src-with-plugins";
  inherit (caddy) version;
  dontUnpack = true;

  nativeBuildInputs = [
    git
    go
    xcaddy
    cacert
  ];

  buildPhase =
    let
      with-plugins = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"

      XCADDY_SKIP_BUILD=1 TMPDIR="$PWD" xcaddy build "v${version}" ${with-plugins}
      (cd buildenv* && go mod vendor)

      runHook postBuild
    '';

  installPhase = ''
    mv buildenv* $out
  '';

  inherit outputHash;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
