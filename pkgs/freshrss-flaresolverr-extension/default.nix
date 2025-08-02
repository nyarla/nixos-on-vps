{ freshrss-extensions, fetchFromGitHub }:
freshrss-extensions.buildFreshRssExtension {
  FreshRssExtUniqueId = "FlareSolverr";
  pname = "freshrss-flaresolverr-extension";
  version = "main";
  src = fetchFromGitHub {
    owner = "ravenscroftj";
    repo = "freshrss-flaresolverr-extension";
    rev = "ae9027337153942d8ef5f24d040171bdbf43345c";
    hash = "sha256-JNLDMay1kPRhkgtWXIHYxlOMz3ngw8u5MDJRkSp+lqg=";
  };

  preBuild = ''
    sed -i "s/\$filename = 'cloudsolver.php';/return true;/" extension.php
  '';
}
