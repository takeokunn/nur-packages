{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "gogcli";
  version = "0.34.2";
  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-op6R5Q7GX0Oi6T7KKR71Zim7QqzO79+x/TTWN3SQQ88=";
  };
  vendorHash = "sha256-e6frnFi+e+0CPb7hcR7X/1n5j2cOavHEay9WXXPWMnI=";

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
