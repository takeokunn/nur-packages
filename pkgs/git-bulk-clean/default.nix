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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "git-bulk-clean";
    tag = "v${version}";
    hash = "sha256-fONQE4zeV2dJg8s95lqWsZgTdY2/3qbyhBmHbYIFdhc=";
  };

  cargoHash = "sha256-MlIDwqnB80sdyG1x0DFzKz1+2VzRA5sYPyiDhgZkRA8=";

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
