{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "web-php-blade-mode";
  version = "unstable-2024-10-16";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "web-php-blade-mode";
    rev = "a4463d2732caa8c3650826ee4fc79f3fd29c9e56";
    hash = "sha256-hZKMck0xJWTub81yCupCie+Z8FFFFP26IRm7uN/mbTI=";
  };

  meta = {
    description = "Laravel Blade template mode for Emacs using web-mode";
    homepage = "https://github.com/takeokunn/web-php-blade-mode";
    license = lib.licenses.gpl3Plus;
  };
}
