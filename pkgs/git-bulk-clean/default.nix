{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  scdoc,
  git,
  ghq,
  coreutils,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-bulk-clean";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "git-bulk-clean";
    tag = "v${version}";
    hash = "sha256-lP3thFnW8vCH1fmNutuinVcU/QEmaYV1n5EI7rShfkY=";
  };

  cargoHash = "sha256-8BFYKPpGn/X3Ry4SScnlnIDZUVAx17Gu1bcvUhaUc/0=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    scdoc
  ];

  # The test suite shells out to git.
  nativeCheckInputs = [ git ];
  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    wrapProgram $out/bin/git-bulk-clean \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          ghq
          coreutils
        ]
      }

    $out/bin/git-bulk-clean --generate-completions bash > completion.bash
    $out/bin/git-bulk-clean --generate-completions zsh  > completion.zsh
    $out/bin/git-bulk-clean --generate-completions fish > completion.fish
    install -Dm644 completion.bash $out/share/bash-completion/completions/git-bulk-clean
    install -Dm644 completion.zsh  $out/share/zsh/site-functions/_git-bulk-clean
    install -Dm644 completion.fish $out/share/fish/vendor_completions.d/git-bulk-clean.fish

    scdoc < man/git-bulk-clean.1.scd > git-bulk-clean.1
    installManPage git-bulk-clean.1
  '';

  meta = {
    description = "Parallel Git repository maintenance CLI and daemon";
    homepage = "https://github.com/takeokunn/git-bulk-clean";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "git-bulk-clean";
  };
}
