{ freshrss-extensions, fetchFromGitHub }:
freshrss-extensions.buildFreshRssExtension {
  FreshRssExtUniqueId = "FlareSolverr";
  pname = "freshrss-flaresolverr-extension";
  version = "main";
  src = fetchFromGitHub {
    owner = "ravenscroftj";
    repo = "freshrss-flaresolverr-extension";
    rev = "82a34ea98b16b20926d3994f0d6f1504f5e5fef0";
    hash = "sha256-ahlYeKQMROIx8z/fSKXd749xKj1fCH7VU7S8xPh0giI=";
  };

  preBuild = ''
    sed -i "s/\$filename = 'cloudsolver.php';/return true;/" extension.php
  '';
}
