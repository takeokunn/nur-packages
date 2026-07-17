{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "gogcli";
  version = "0.34.1";
  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-ocC+A63GLrZQA3mXEPjIfsM7Af9NiYjGF8DZI/2yNS0=";
  };
  vendorHash = "sha256-MAbbCLdoOLWer7HO3+RZJuN10gLeTgN6/CbNn6pzGwQ=";

  doCheck = false;

  meta = {
    description = "Fast, script-friendly CLI for Google Workspace (Gmail, Calendar, Chat, Drive, Docs, Sheets, Tasks, etc.) with JSON output";
    homepage = "https://github.com/steipete/gogcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "gog";
  };
}
