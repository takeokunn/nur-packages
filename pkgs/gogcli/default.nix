{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "gogcli";
  version = "0.47.0";
  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-IQq1fOEtPWaGVCoYiKEfhNUz5kaGgOjAr/7GwiGZnlg=";
  };
  vendorHash = "sha256-pvmn4tRoom5Y9z8w6bY9YaEbEybae4cjBrdB20qF8/Q=";

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
