{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "soft-narrow";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "soft-narrow";
    rev = "refs/tags/v0.1.0";
    hash = "sha256-jlOaMKZbkN6kh04uJ4xslpRA29zYvz1yDCPJPDb7rFw=";
  };

  meta = {
    description = "Narrow-to-region with more eye-candy";
    homepage = "https://github.com/takeokunn/soft-narrow";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
