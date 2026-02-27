{
  lib,
  stdenvNoCC,
  git,
}:

stdenvNoCC.mkDerivation {
  pname = "diff-highlight";
  version = lib.getVersion git;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ${git}/share/git/contrib/diff-highlight/diff-highlight $out/bin/diff-highlight
    chmod +x $out/bin/diff-highlight
    runHook postInstall
  '';

  meta = {
    description = "Highlight changed parts of lines in git diff output";
    homepage = "https://github.com/git/git/tree/master/contrib/diff-highlight";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
    mainProgram = "diff-highlight";
  };
}
