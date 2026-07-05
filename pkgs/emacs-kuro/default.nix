{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "kuro";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "kuro";
    rev = "ff306f56c63cbe2a6471d51728a14f9aec474ded";
    hash = "sha256-MQpgJG0/mrgi0zt7NIt/G1LL++ps6XjAPvmgh9snMKQ=";
  };

  # kuro's Emacs Lisp layer is split across emacs-lisp/{core,faces,features,ffi,input,rendering}/*.el.
  # kuro.el only wires those subdirectories onto load-path when they exist next to it (source-tree
  # checkout); once installed flat into a single site-lisp directory that dolist finds nothing and
  # is a no-op, so flattening here is the exact layout upstream packages for.
  postUnpack = ''
    find "$sourceRoot/emacs-lisp" -mindepth 2 -name '*.el' -exec mv -t "$sourceRoot/emacs-lisp" {} +
  '';

  sourceRoot = "source/emacs-lisp";

  meta = {
    description = "Kuro terminal emulator for Emacs (Emacs Lisp display layer)";
    homepage = "https://github.com/takeokunn/kuro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
