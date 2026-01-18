# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  isucrud = pkgs.callPackage ./pkgs/isucrud { };
  tcardgen = pkgs.callPackage ./pkgs/tcardgen { };
  runn = pkgs.callPackage ./pkgs/runn { };
  textlint-rule-preset-japanese = pkgs.callPackage ./pkgs/textlint-rule-preset-japanese { };
  tbls-ask = pkgs.callPackage ./pkgs/tbls-ask { };
  pict = pkgs.callPackage ./pkgs/pict { };
  terraform-mcp-server = pkgs.callPackage ./pkgs/terraform-mcp-server { };

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

  # Themes and syntax
  dracula-tig = pkgs.callPackage ./pkgs/dracula-tig { };
  dracula-sublime = pkgs.callPackage ./pkgs/dracula-sublime { };
  sublime-gleam = pkgs.callPackage ./pkgs/sublime-gleam { };
  sublime-justfile = pkgs.callPackage ./pkgs/sublime-justfile { };

  # Emacs packages
  emacs-rainbow-csv = pkgs.callPackage ./pkgs/emacs-rainbow-csv { };
  emacs-php-doc-block = pkgs.callPackage ./pkgs/emacs-php-doc-block { };
  emacs-fish-repl = pkgs.callPackage ./pkgs/emacs-fish-repl { };
  emacs-systemd-mode = pkgs.callPackage ./pkgs/emacs-systemd-mode { };
  emacs-web-php-blade-mode = pkgs.callPackage ./pkgs/emacs-web-php-blade-mode { };
  emacs-org-volume = pkgs.callPackage ./pkgs/emacs-org-volume { };
  emacs-ob-phpstan = pkgs.callPackage ./pkgs/emacs-ob-phpstan { };
  emacs-ob-treesitter = pkgs.callPackage ./pkgs/emacs-ob-treesitter { };
  emacs-ob-racket = pkgs.callPackage ./pkgs/emacs-ob-racket { };
  emacs-ox-hatena = pkgs.callPackage ./pkgs/emacs-ox-hatena { };
  emacs-consult-tramp = pkgs.callPackage ./pkgs/emacs-consult-tramp { };
  emacs-explain-pause-mode = pkgs.callPackage ./pkgs/emacs-explain-pause-mode { };
  emacs-mu4e-dashboard = pkgs.callPackage ./pkgs/emacs-mu4e-dashboard { };
  emacs-sudden-death = pkgs.callPackage ./pkgs/emacs-sudden-death { };
  emacs-zalgo-mode = pkgs.callPackage ./pkgs/emacs-zalgo-mode { };
  emacs-ob-fish = pkgs.callPackage ./pkgs/emacs-ob-fish { };
  emacs-typst-mode = pkgs.callPackage ./pkgs/emacs-typst-mode { };
}
