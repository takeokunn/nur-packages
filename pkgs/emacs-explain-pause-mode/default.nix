{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "explain-pause-mode";
  version = "unstable-2020-10-05";

  src = fetchFromGitHub {
    owner = "lastquestion";
    repo = "explain-pause-mode";
    rev = "ac3eb69f36f345506aad05a6d9bc3ef80d26914b";
    hash = "sha256-6FDYnE9rT12f2Lx3yg2tpDVm9txF2VoVxZvADpm4BoM=";
  };

  meta = {
    description = "Top-like interface for Emacs to debug performance";
    homepage = "https://github.com/lastquestion/explain-pause-mode";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
