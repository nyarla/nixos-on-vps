{ fetchFromGitHub, buildGo123Module }:
buildGo123Module {
  pname = "litestream";
  version = "git";
  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "996a50deaf0350e4450053bf54a8e350f37116c4";
    hash = "sha256-cVLPL+mkJ1hSwl1oD/zExRgvF2ofMXxAx7ZPWq7Zoms=";

  };

  vendorHash = "sha256-PlfDJbhzbH/ZgtQ35KcB6HtPEDTDgss7Lv8BcKT/Dgg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=996a50d"
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
