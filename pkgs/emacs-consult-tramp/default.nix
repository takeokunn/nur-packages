{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "consult-tramp";
  version = "unstable-2024-06-19";

  src = fetchFromGitHub {
    owner = "Ladicle";
    repo = "consult-tramp";
    rev = "456728d98c334522cefbfe059480daf7516ea309";
    hash = "sha256-ZLzjHscapGGLbIpjy/WYa4O3uqKobmHBt+D7t1HumXs=";
  };

  packageRequires = [ emacsPackages.consult ];

  meta = {
    description = "Consult interface for TRAMP";
    homepage = "https://github.com/Ladicle/consult-tramp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
