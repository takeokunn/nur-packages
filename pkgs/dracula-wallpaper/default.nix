{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-wallpaper";
  version = "unstable-2023-11-14";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "wallpaper";
    rev = "f2b8cc4223bcc2dfd5f165ab80f701bbb84e3303";
    hash = "sha256-P0MfGkVap8wDd6eSMwmLhvQ4/7Z+pNmgY7O+qt9C1bg=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r first-collection $out/
  '';

  meta = {
    description = "Dracula wallpaper collection";
    homepage = "https://github.com/dracula/wallpaper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
