{
  pkgs ? import <nixpkgs> { },
}:
let
  version = "263.6379.0";
in
pkgs.stdenv.mkDerivation {
  pname = "kotlin-lsp";
  version = version;

  src = pkgs.fetchzip {
    url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.tar.gz";
    hash = "sha256-MQZ2Q70IYbVpKVg8D7yjK/jpboMuNjKGslxFOw+6b9I=";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    alsa-lib
    freetype
    libx11
    libxext
    libxi
    libxkbcommon
    libxrender
    libxtst
    stdenv.cc.cc.lib
    wayland
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/kotlin-lsp
    cp -r * $out/share/kotlin-lsp/
    ln -s $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp
  '';
}
