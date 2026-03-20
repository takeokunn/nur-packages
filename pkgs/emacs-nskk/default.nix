{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "nskk";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "nskk.el";
    rev = "v0.1.13";
    hash = "sha256-vk3j1thFU8tB3skQDUhpGeZ9Gt9ON9z9qG2oDGTwy5k=";
  };

  meta = {
    description = "NSKK - SKK Japanese input method for Emacs";
    homepage = "https://github.com/takeokunn/nskk.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
