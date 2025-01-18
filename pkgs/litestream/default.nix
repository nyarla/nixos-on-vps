{ fetchFromGitHub, buildGo123Module }:
buildGo123Module {
  pname = "litestream";
  version = "git";
  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "2f22a4babf8bc19712b23bbb31d0ef6020cf78b0";
    hash = "sha256-ZJFdWsqILyoNX1/hbX19HmMVdgFCxAN52wL+bcsQcJs=";
  };

  vendorHash = "sha256-PlfDJbhzbH/ZgtQ35KcB6HtPEDTDgss7Lv8BcKT/Dgg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=2f22a4b"
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
