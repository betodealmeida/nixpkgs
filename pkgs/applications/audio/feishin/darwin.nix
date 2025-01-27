{ stdenv
, lib
, fetchurl
, mpv
, electron_24
, makeDesktopItem
, makeWrapper
, pname
, appname
, version
}:

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/v${version}/${appname}-${version}-mac-x64.zip"
    hash = "sha256-WzU/Yd3cNMIpmkKWC29mQlviYXiYV5k8+80iyzilPGc=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  # Installs mpv as a requirement
  propagatedBuildInputs = [ mpv ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications/${appname}.app,bin}
    cp -R . $out/Applications/${appname}.app
    makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
    runHook postInstall
  '';

  shellHook = ''
    set -x
    export LD_LIBRARY_PATH=${mpv}/lib
    set +x
  '';
}
