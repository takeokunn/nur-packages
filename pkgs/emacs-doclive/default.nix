{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "doclive";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "doclive";
    rev = "c1433600c4a15cb7e2c1414a1a5c0a492f8d59f4";
    hash = "sha256-mbsgejtARAGH29Gd5S/d2mXdErPbWgOK7gH9kvVTqR0=";
  };

  packageRequires = [ emacsPackages.org ];

  meta = with lib; {
    description = "Fast Markdown and Org preview for AI docs";
    homepage = "https://github.com/takeokunn/doclive";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ takeokunn ];
    platforms = platforms.all;
  };
}
