{ freshrss-extensions, fetchFromGitHub }:
freshrss-extensions.buildFreshRssExtension {
  FreshRssExtUniqueId = "FlareSolverr";
  pname = "freshrss-flaresolverr-extension";
  version = "main";
  src = fetchFromGitHub {
    owner = "ravenscroftj";
    repo = "freshrss-flaresolverr-extension";
    rev = "46f625f102e319b7c0d155615622abe095a6ddde";
    hash = "sha256-zxMmY/uXvIi3Ou4kxb6Gac7DAv8rtFilzz6h5l/B2wo=";
  };
}
