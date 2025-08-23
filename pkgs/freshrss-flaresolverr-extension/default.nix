{ freshrss-extensions, fetchFromGitHub }:
freshrss-extensions.buildFreshRssExtension {
  FreshRssExtUniqueId = "FlareSolverr";
  pname = "freshrss-flaresolverr-extension";
  version = "main";
  src = fetchFromGitHub {
    owner = "ravenscroftj";
    repo = "freshrss-flaresolverr-extension";
    rev = "abd66220c18231b6c159c98db650dec436560d4d";
    hash = "sha256-KFPyBqHHdVCGxIfTpLS4R3PfMTKJg7X2kEhgIwodGUc=";
  };

  preBuild = ''
    sed -i "s/\$filename = 'cloudsolver.php';/return true;/" extension.php
  '';
}
