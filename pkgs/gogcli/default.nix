{ buildGo125Module, fetchFromGitHub }:
buildGo125Module {
  pname = "gogcli";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "refs/tags/v0.9.0";
    hash = "sha256-DXRw5jf/5fC8rgwLIy5m9qkxy3zQNrUpVG5C0RV7zKM=";
  };
  vendorHash = "sha256-nig3GI7eM1XRtIoAh1qH+9PxPPGynl01dCZ2ppyhmzU=";

  doCheck = false;

  meta = {
    description = "Fast, script-friendly CLI for Google Workspace (Gmail, Calendar, Chat, Drive, Docs, Sheets, Tasks, etc.) with JSON output";
    homepage = "https://github.com/steipete/gogcli";
    mainProgram = "gog";
  };
}
