{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "mu4e-dashboard";
  version = "unstable-2024-05-28";

  src = fetchFromGitHub {
    owner = "rougier";
    repo = "mu4e-dashboard";
    rev = "c9c09b7ed6433070de148b656ac273b7fb7cec07";
    hash = "sha256-bCelxaT+qaR2W80Cr591A4cRycIFJmXjeY8/aqIpl5g=";
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
