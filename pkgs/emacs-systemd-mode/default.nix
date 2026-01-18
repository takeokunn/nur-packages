{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "systemd-mode";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "holomorph";
    repo = "systemd-mode";
    rev = "8742607120fbc440821acbc351fda1e8e68a8806";
    hash = "sha256-oj/E+b3oS/2QNNxTYDZ5Zwq/OHKI2FgN/eRV5EAexrE=";
  };

  preBuild = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.txt $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Emacs major mode for editing systemd units";
    homepage = "https://github.com/holomorph/systemd-mode";
    license = lib.licenses.gpl3Plus;
  };
}
