# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
  emacsPackages ? pkgs.emacsPackages,
  craneLib ? null,
}:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  devenv = pkgs.callPackage ./pkgs/devenv { };
  diff-highlight = pkgs.callPackage ./pkgs/diff-highlight { };
  eldev = pkgs.callPackage ./pkgs/eldev { };
  isucrud = pkgs.callPackage ./pkgs/isucrud { };
  tcardgen = pkgs.callPackage ./pkgs/tcardgen { };
  textlint-rule-preset-japanese = pkgs.callPackage ./pkgs/textlint-rule-preset-japanese { };
  tbls-ask = pkgs.callPackage ./pkgs/tbls-ask { };
  pict = pkgs.callPackage ./pkgs/pict { };
  gogcli = pkgs.callPackage ./pkgs/gogcli { };
  git-bulk-clean = pkgs.callPackage ./pkgs/git-bulk-clean { };
  z_ai-coding-helper = pkgs.callPackage ./pkgs/z_ai-coding-helper { };
  metabase-mcp = pkgs.callPackage ./pkgs/metabase-mcp { };
  ast-grep-mcp = pkgs.callPackage ./pkgs/ast-grep-mcp { };
  serena = pkgs.callPackage ./pkgs/serena { };
  oh-my-openagent =
    if
      builtins.elem pkgs.stdenv.hostPlatform.system [
        "aarch64-darwin"
        "x86_64-linux"
      ]
    then
      pkgs.callPackage ./pkgs/oh-my-openagent { }
    else
      null;
  kakehashi = pkgs.callPackage ./pkgs/kakehashi { };
  kuro = pkgs.callPackage ./pkgs/kuro { };
  tmux-dart = pkgs.callPackage ./pkgs/tmux-dart { };
  # Swift toolchain and packages (Darwin only)
  swift-bin = if pkgs.stdenv.isDarwin then pkgs.callPackage ./pkgs/swift-bin { } else null;
  swift-argument-parser =
    if pkgs.stdenv.isDarwin then pkgs.callPackage ./pkgs/swift-argument-parser { } else null;
  swift-testing = if pkgs.stdenv.isDarwin then pkgs.callPackage ./pkgs/swift-testing { } else null;
  swift-syntax = if pkgs.stdenv.isDarwin then pkgs.callPackage ./pkgs/swift-syntax { } else null;

  # Desktop apps (macOS)
  arto = if craneLib != null then pkgs.callPackage ./pkgs/arto { inherit craneLib; } else null;

  # Fish plugins
  fish-artisan-completion = pkgs.callPackage ./pkgs/fish-artisan-completion { };
  fish-ghq = pkgs.callPackage ./pkgs/fish-ghq { };
  dracula-fish = pkgs.callPackage ./pkgs/dracula-fish { };
  fish-nix-completions = pkgs.callPackage ./pkgs/fish-nix-completions { };
  fish-nix-env = pkgs.callPackage ./pkgs/fish-nix-env { };
  fish-dart-completions = pkgs.callPackage ./pkgs/fish-dart-completions { };
  fish-by-binds-yourself = pkgs.callPackage ./pkgs/fish-by-binds-yourself { };

  # Vim/Neovim plugins
  vimdoc-ja = pkgs.callPackage ./pkgs/vimdoc-ja { };
  vim-skkeleton = pkgs.callPackage ./pkgs/vim-skkeleton { };
  vim-skkeleton-azik = pkgs.callPackage ./pkgs/vim-skkeleton-azik { };
  nvim-aibo = pkgs.callPackage ./pkgs/nvim-aibo { };

  # Org-mode themes
  readthezero = pkgs.callPackage ./pkgs/readthezero { };

  # Themes and syntax
  dracula-wallpaper = pkgs.callPackage ./pkgs/dracula-wallpaper { };
  dracula-tig = pkgs.callPackage ./pkgs/dracula-tig { };
  dracula-sublime = pkgs.callPackage ./pkgs/dracula-sublime { };
  sublime-gleam = pkgs.callPackage ./pkgs/sublime-gleam { };
  sublime-justfile = pkgs.callPackage ./pkgs/sublime-justfile { };

  # Emacs packages
  emacs-arto = pkgs.callPackage ./pkgs/emacs-arto { inherit emacsPackages; };
  emacs-rainbow-csv = pkgs.callPackage ./pkgs/emacs-rainbow-csv { inherit emacsPackages; };
  emacs-soft-narrow = pkgs.callPackage ./pkgs/emacs-soft-narrow { inherit emacsPackages; };
  emacs-php-doc-block = pkgs.callPackage ./pkgs/emacs-php-doc-block { inherit emacsPackages; };
  emacs-fish-repl = pkgs.callPackage ./pkgs/emacs-fish-repl { inherit emacsPackages; };
  emacs-systemd-mode = pkgs.callPackage ./pkgs/emacs-systemd-mode { inherit emacsPackages; };
  emacs-web-php-blade-mode = pkgs.callPackage ./pkgs/emacs-web-php-blade-mode { inherit emacsPackages; };
  emacs-org-volume = pkgs.callPackage ./pkgs/emacs-org-volume { inherit emacsPackages; };
  emacs-ob-phpstan = pkgs.callPackage ./pkgs/emacs-ob-phpstan { inherit emacsPackages; };
  emacs-ob-treesitter = pkgs.callPackage ./pkgs/emacs-ob-treesitter { inherit emacsPackages; };
  emacs-ob-racket = pkgs.callPackage ./pkgs/emacs-ob-racket { inherit emacsPackages; };
  emacs-ox-hatena = pkgs.callPackage ./pkgs/emacs-ox-hatena { inherit emacsPackages; };
  emacs-consult-tramp = pkgs.callPackage ./pkgs/emacs-consult-tramp { inherit emacsPackages; };
  emacs-explain-pause-mode = pkgs.callPackage ./pkgs/emacs-explain-pause-mode { inherit emacsPackages; };
  emacs-mu4e-dashboard = pkgs.callPackage ./pkgs/emacs-mu4e-dashboard { inherit emacsPackages; };
  emacs-nskk = pkgs.callPackage ./pkgs/emacs-nskk { inherit emacsPackages; };
  emacs-sudden-death = pkgs.callPackage ./pkgs/emacs-sudden-death { inherit emacsPackages; };
  emacs-zalgo-mode = pkgs.callPackage ./pkgs/emacs-zalgo-mode { inherit emacsPackages; };
  emacs-ob-fish = pkgs.callPackage ./pkgs/emacs-ob-fish { inherit emacsPackages; };
  emacs-typst-mode = pkgs.callPackage ./pkgs/emacs-typst-mode { inherit emacsPackages; };
  emacs-warm-mode = pkgs.callPackage ./pkgs/emacs-warm-mode { inherit emacsPackages; };
  emacs-dasel = pkgs.callPackage ./pkgs/emacs-dasel { inherit emacsPackages; };
  emacs-consult-dasel =
    let
      emacs-dasel = pkgs.callPackage ./pkgs/emacs-dasel { inherit emacsPackages; };
    in
    pkgs.callPackage ./pkgs/emacs-consult-dasel { inherit emacs-dasel emacsPackages; };
}
