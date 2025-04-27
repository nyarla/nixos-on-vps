{
  runCommand,

  fetchFromGitHub,
  fetchYarnDeps,

  buildGo123Module,
  mkYarnPackage,
}:
let
  version = "v0.19.0+kalaclista";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = "gotosocial-kalaclista";
    rev = "04b6dbaa8f79cbc5d99686a9b602b8f0b10a0b04";
    hash = "sha256-DSbAH3AqgNm6GtX/0wZrBE/9pnetf3GZ/rUrQGK2a2Y=";
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
      hash = "sha256-hWWe3vJp1IXHCZOUAsjjQDEFqZgyjUVFe082dvEKPVw=";
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
