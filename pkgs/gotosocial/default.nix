{
  runCommand,

  fetchFromGitHub,
  fetchYarnDeps,

  buildGo122Module,
  mkYarnPackage,
}:
let
  version = "v0.17.3+kalaclista";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "gotosocial-modded";
    rev = "8b9e9df3085782084844587ba0e9d26b5935c72f";
    hash = "sha256-vidRTWcStahzjDSHf1BPug4PvrhRSXkJmk+1SNHtgnQ=";
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
      hash = "sha256-Sx2OaxwFqbT91BnumLxRB1fkvKOxzpkqlpF7RUoLX04=";
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
buildGo122Module rec {
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
