{
  runCommand,

  fetchFromGitHub,
  fetchYarnDeps,

  buildGo123Module,
  mkYarnPackage,
}:
let
  version = "v0.18.0+kalaclista";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "gotosocial-modded";
    rev = "80d157831a8b03139f60ef8c4a6d542800a308b9";
    hash = "sha256-kyA41uFSYQfPLaiMA7/8TTQe99uKAu7cTTYRQY8XSqA=";

  };

  assets = runCommand "web" { } ''
    mkdir -p $out/
    cp -r ${src}/web/source/* $out/
  '';

  web = mkYarnPackage {
    pname = "gotosocial-web";
    inherit version;
    src = assets;

    packageJSON = assets + /package.json;
    offlineCache = fetchYarnDeps {
      yarnLock = assets + /yarn.lock;
      hash = "sha256-n+4q/1hMzBEsMuBItld0ziAYiBDx3S0EAWojqsfFA38=";
    };

    buildPhase = ''
      runHook preBuild

      yarn --offline ts-patch install
      yarn --offline build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/gotosocial/web
      cp -r ${src}/web/template $out/share/gotosocial/web/template
      cp -r ${src}/web/assets $out/share/gotosocial/web/assets

      chmod -R +w $out/share/gotosocial/web/assets
      cp -r deps/assets/dist $out/share/gotosocial/web/assets/dist

      runHook postInstall
    '';

    doDist = false;
  };

in
buildGo123Module rec {
  pname = "gotosocial";
  inherit version;
  inherit src;

  vendorHash = null;

  subPackages = [
    "cmd/gotosocial"
    "cmd/process-emoji"
    "cmd/process-media"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  tags = [
    "kvformat"
    "netgo"
    "nometric"
    "notracing"
    "osusergo"
    "static_build"
    "timetzdata"
  ];

  postInstall = ''
    cp -r ${web}/share $out/
  '';
}
