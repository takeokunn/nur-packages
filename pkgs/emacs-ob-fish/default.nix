{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ob-fish";
  version = "unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "ob-fish";
    rev = "4cf4b8bcd58e8fad45d8f690fbdf9cafc2958748";
    hash = "sha256-BMi6NN1ZXr2EcvPCtIcUz9RKtrA045tYYZUPM1FQao4=";
  };

  meta = {
    description = "Org-babel functions for fish shell";
    homepage = "https://github.com/takeokunn/ob-fish";
    license = lib.licenses.gpl3Plus;
  };
}
