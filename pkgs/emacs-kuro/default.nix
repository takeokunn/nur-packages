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
    find "$sourceRoot" -mindepth 2 -name '*.el' -exec mv -t "$sourceRoot" {} +
  '';

  sourceRoot = "source/emacs-lisp";

  # trivialBuild's default buildPhase byte-compiles *.el in plain alphabetical
  # order with a fresh Emacs. kuro-lifecycle-macros.el defines a macro whose
  # expansion reads the *value* of kuro--session-setup-fns (a defconst in
  # kuro-lifecycle.el, same file the macro is used from) at macro-expansion
  # time, not at runtime. Loading the whole package via `require` first --
  # exactly what upstream's own byte-compile check does -- makes that value
  # (and every other cross-file binding) available before any file is
  # compiled, regardless of compile order.
  buildPhase = ''
    runHook preBuild
    emacs -l package -f package-initialize \
      --eval "(setq byte-compile-debug t)" \
      --eval "(setq byte-compile-error-on-warn nil)" \
      -L . --batch \
      --eval "(require 'kuro)" \
      -f batch-byte-compile *.el
    runHook postBuild
  '';

  # nixpkgs' emacs build support natively-compiles every installed .el file
  # in its own postInstall hook, one isolated `emacs --batch` process per
  # file (see build-support/generic.nix), independent of the buildPhase
  # above. That isolated, per-file native-compile pass hits the same
  # kuro--session-setup-fns macro-expansion-time value read described above,
  # but this time with no way to `require 'kuro` first (it's a fixed
  # nixpkgs-provided hook, not something this package's buildPhase can
  # sequence). ignoreCompilationError makes that hook non-fatal: the file
  # still has a working .elc from the buildPhase above and Emacs falls back
  # to it when no .eln is present, so this only costs native-comp's speedup
  # for the handful of files affected, not correctness.
  ignoreCompilationError = true;

  meta = {
    description = "Kuro terminal emulator for Emacs (Emacs Lisp display layer)";
    homepage = "https://github.com/takeokunn/kuro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
