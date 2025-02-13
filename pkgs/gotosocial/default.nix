{
  runCommand,

  fetchFromGitHub,
  fetchYarnDeps,

  buildGo123Module,
  mkYarnPackage,
}:
let
  version = "v0.18.0-rc1+kalaclista";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "gotosocial-modded";
    rev = "084f8ae99157e75183c6c21200ecb7618f927dc3";
    hash = "sha256-lk9zdPUc8+PfkH4sX1UzUfp4ldfrZp7i+SoPDA26a7o=";
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
      hash = "sha256-H2uysEsuxkPP6Pvu8r8A1aEA75z2/lx625FklZxSdnA=";
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
