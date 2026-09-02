{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "gogcli";
  version = "0.38.2";
  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-o2o/VTUj6b2lJjdsS8p3WIXlXSA/P6iN/fFtukn0+rU=";
  };
  vendorHash = "sha256-o84M81MKbXMNBh1QXyZjSoUS5Oq8SjC6HQUOM2I2Rbg=";

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
