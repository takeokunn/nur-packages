{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "gogcli";
  version = "0.15.0";
  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-8ffexCQWQXaaEyiWIKxg8M2VdgLDMqTiadCu/8v3DE0=";
  };
  vendorHash = "sha256-gcbzmq3TvG9Ii7J2B48nbwNkUUvcdfTqU3RlcxGGqyE=";

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
