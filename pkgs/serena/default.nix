{
  darwin,
  lib,
  fetchFromGitHub,
  fortls,
  nodejs,
  pyright,
  python3Packages,
  stdenv,
}:

let
  pyobjc-framework-uniformtypeidentifiers = python3Packages.buildPythonPackage {
    pname = "pyobjc-framework-uniformtypeidentifiers";
    pyproject = true;

    inherit (python3Packages.pyobjc-core) version src patches;

    sourceRoot = "${python3Packages.pyobjc-core.src.name}/pyobjc-framework-UniformTypeIdentifiers";

    build-system = [ python3Packages.setuptools ];

    buildInputs = [ darwin.libffi ];
    nativeBuildInputs = [ darwin.DarwinTools ];

    postPatch = ''
      substituteInPlace pyobjc_setup.py \
        --replace-fail "-buildversion" "-buildVersion" \
        --replace-fail "-productversion" "-productVersion" \
        --replace-fail "/usr/bin/sw_vers" "sw_vers" \
        --replace-fail "/usr/bin/xcrun" "xcrun"
    '';

    dependencies = with python3Packages; [
      pyobjc-core
      pyobjc-framework-Cocoa
    ];

    env.NIX_CFLAGS_COMPILE = toString [
      "-I${darwin.libffi.dev}/include"
      "-Wno-error=unused-command-line-argument"
    ];

    doCheck = false;

    pythonImportsCheck = [ "UniformTypeIdentifiers" ];

    meta = {
      description = "PyObjC wrappers for the UniformTypeIdentifiers framework on macOS";
      homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-framework-UniformTypeIdentifiers";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  pywebview = python3Packages.pywebview.overridePythonAttrs (
    old:
    lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      # nixpkgs' pywebview always depends on pyside6 (Qt), even on Darwin where
      # pyobjc already provides the native Cocoa backend. pywebview picks its
      # backend dynamically at runtime, so dropping the unused Qt backend here
      # avoids building qtconnectivity, whose linking crashes Apple's ld on
      # this host (`Trace/BPT trap: 5`, exit 133) with no cached build available.
      dependencies =
        (builtins.filter (
          dep: dep != python3Packages.pyside6 && dep != python3Packages.qtpy
        ) (old.dependencies or [ ]))
        ++ [ pyobjc-framework-uniformtypeidentifiers ];
      # nixpkgs marks this broken because its last successful Darwin Hydra build is old.
      # This override builds on Darwin.
      meta = old.meta // {
        broken = false;
      };
    }
  );
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "serena";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oraios";
    repo = "serena";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rwaZ8DmUKgdgi3lWRN2M67ZJLnJGfe76/V+a+zjAaMU=";
  };

  postPatch = ''
    substituteInPlace src/solidlsp/language_servers/pyright_server.py \
      --replace-fail '            self._custom_settings,' \
        '            SolidLSPSettings.CustomLSSettings({**self._custom_settings.settings, "ls_path": self._custom_settings.get("ls_path", "${lib.getExe' pyright "pyright-langserver"}")}),'
  '';

  build-system = [ python3Packages.hatchling ];

  pythonRelaxDeps = true;

  dependencies =
    (with python3Packages; [
      anthropic
      beautifulsoup4
      click
      cryptography
      docstring-parser
      flask
      jinja2
      joblib
      lsprotocol
      mcp
      oslex
      overrides
      pathspec
      psutil
      pydantic
      pygls
      pystray
      python-dotenv
      python-multipart
      pyyaml
      requests
      ruamel-yaml
      sensai-utils
      tiktoken
      tqdm
      types-pyyaml
    ])
    ++ [
      fortls
      pywebview
    ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      nodejs
    ])
  ];

  doCheck = false;

  meta = {
    description = "Powerful coding agent toolkit providing semantic retrieval and editing capabilities";
    homepage = "https://github.com/oraios/serena";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "serena";
    platforms = lib.platforms.unix;
  };
})
