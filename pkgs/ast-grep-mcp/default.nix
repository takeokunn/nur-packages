{
  lib,
  python313Packages,
  fetchFromGitHub,
  ast-grep,
}:

python313Packages.buildPythonApplication {
  pname = "ast-grep-mcp";
  version = "0.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep-mcp";
    rev = "51d5a23f025c73c02032a98748dc06942548c5e1";
    hash = "sha256-1Ajt7VGnYi7S+SteX/65HEOB4SXGGGZbyucGD2+d0AE=";
  };

  postPatch = ''
    echo "" >> pyproject.toml
    echo '[build-system]' >> pyproject.toml
    echo 'requires = ["setuptools"]' >> pyproject.toml
    echo 'build-backend = "setuptools.build_meta"' >> pyproject.toml
    echo "" >> pyproject.toml
    echo '[tool.setuptools]' >> pyproject.toml
    echo 'py-modules = ["main"]' >> pyproject.toml
  '';

  # Upstream pins exact versions with uv; nixpkgs moves them independently.
  pythonRelaxDeps = true;

  build-system = with python313Packages; [ setuptools ];

  dependencies = with python313Packages; [
    pydantic
    pyyaml
    mcp
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ast-grep ])
  ];

  meta = {
    description = "MCP server providing structural code search via ast-grep";
    homepage = "https://github.com/ast-grep/ast-grep-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    mainProgram = "ast-grep-server";
    platforms = lib.platforms.unix;
  };
}
