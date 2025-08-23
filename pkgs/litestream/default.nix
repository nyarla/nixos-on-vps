{ fetchFromGitHub, buildGo124Module }:
buildGo124Module {
  pname = "litestream";
  version = "git";
  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "feee71f6a90b464ee74da337043f3ad5d59a6b05";
    hash = "sha256-GdCiKiawVPFd+eNc5Yr1//nRg+WE/JjYo7uepAdn2bU=";
  };

  vendorHash = "sha256-y2gI5dk/tgjmrSnUapPl3MpMdzUl49zSiG93EZtmCgw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=feee71f"
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
