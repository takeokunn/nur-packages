{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "dracula-fish";
  version = "unstable-2022-10-24";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "fish";
    rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
    hash = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
  };

  meta = {
    description = "Dracula theme for fish shell";
    homepage = "https://github.com/dracula/fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
