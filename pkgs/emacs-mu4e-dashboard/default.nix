{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "mu4e-dashboard";
  version = "unstable-2026-07-20";

  src = fetchFromGitHub {
    owner = "rougier";
    repo = "mu4e-dashboard";
    rev = "d40f501edad5078386e43a74b2bc3e2b22e33009";
    hash = "sha256-RVhhJy1morDbz5UXQ/5jwx1ArtUv0J8vHw23R3nEwiE=";
  };

  packageRequires = with emacsPackages; [
    async
    mu4e
  ];

  meta = {
    description = "A dashboard for mu4e";
    homepage = "https://github.com/rougier/mu4e-dashboard";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
