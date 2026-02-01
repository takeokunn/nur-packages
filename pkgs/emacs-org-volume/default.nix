{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "org-volume";
  version = "unstable-2022-07-17";

  src = fetchFromGitHub {
    owner = "akirak";
    repo = "org-volume";
    rev = "caa30d5b958c9f37854d7ab35c99445c00bc7d1e";
    hash = "sha256-J1DdP10uc6KeWl+ZhsEBifEJ99lDyKlmcuInHa5p3/M=";
  };

  packageRequires = with emacsPackages; [
    dash
    f
    request
  ];

  meta = {
    description = "Manage volumes of Org files";
    homepage = "https://github.com/akirak/org-volume";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
