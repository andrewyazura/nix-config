{
  pkgs,
  lib,
  stdenv,
}:

let
  metamod = pkgs.fetchurl {
    url = "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1410-linux.tar.gz";
    sha256 = "0x3n7krm8jgvx8wfrw1xpia80g5pbvw59wafxdqq5vdajjgdmzxb";
  };

  cssharp = pkgs.fetchurl {
    url = "https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v1.0.371/counterstrikesharp-with-runtime-linux-1.0.371.zip";
    sha256 = "07fh28c21nfcvhmfbn53rdzcsa9z6s44mmf3mzzwjj23ayfnjzs4";
  };

  matchzy = pkgs.fetchurl {
    url = "https://github.com/sivert-io/MatchZy-Enhanced/releases/download/v1.4.23/MatchZy-1.4.23.zip";
    sha256 = "1vvkn8vba60ghspy3r8i20wmy2skkacha12ppgckppmbvc1dbcgs";
  };

in
stdenv.mkDerivation {
  pname = "cs2-plugins";
  version = "1.0";

  nativeBuildInputs = [
    pkgs.unzip
    pkgs.prelink
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    tar -xf ${metamod} -C $out
    unzip -q ${cssharp} -d $out
    unzip -q ${matchzy} -d $out

    # Remove executable stack flag from CounterStrikeSharp to fix the plugin load error
    find $out -name "*.so" -exec sh -c 'execstack -c "$1" 2>/dev/null || true' _ {} \;
  '';
}
