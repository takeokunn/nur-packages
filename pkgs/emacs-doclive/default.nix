{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "doclive";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "doclive";
    rev = "45d861ebd864ad917be849c10a4c8460905e7202";
    hash = "sha256-qDVxDAZW7Ibu0w2CkuRVLAi1ELNC1bgn2w3KHLOnBVM=";
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
