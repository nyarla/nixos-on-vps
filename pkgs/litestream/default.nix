{ fetchFromGitHub, buildGo124Module }:
buildGo124Module {
  pname = "litestream";
  version = "git";
  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "6c35001a521ef832f83b45c4e056cfd719455086";
    hash = "sha256-kwioOomGZAqmY5jvpCSPjp1JHmYrULl7LR6cvtOopuw=";
  };

  vendorHash = "sha256-mpFiTONT27MdZNwAY+DNNWoY+fKDIddRitSzns1R8B8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=6c35001"
  ];

  tags = [
    "osusergo"
    "netgo"
    "sqlite_omit_load_extension"
  ];

  subPackages = [
    "cmd/litestream"
  ];
}
