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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "git-bulk-clean";
    tag = "v${version}";
    hash = "sha256-D/k77Vw8SX7pBdp72cPu1N3BxvvpErSpEmG00fctYMQ=";
  };

  cargoHash = "sha256-6lnVkgecGfQIxj7S46Oh1Tz/FWDd/h6HZ5wIl3VlPyY=";

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
