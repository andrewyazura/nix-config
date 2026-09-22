{
  pkgs,
  lib,
  stdenv,
}:

let
  metamod = pkgs.fetchurl {
    url = "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1469-linux.tar.gz";
    sha256 = "1bbpy4k6lfa5ksy37jx963wicgfxdcghz24j25dd3klr2g5y8lm5";
  };

  cssharp = pkgs.fetchurl {
    url = "https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v1.0.374/counterstrikesharp-with-runtime-linux-1.0.374.zip";
    sha256 = "14k7rins02c8x6a60mm1nmz2czcjw41yqb67rl6ss9p2haj4m8i2";
  };

  matchzy = pkgs.fetchurl {
    url = "https://github.com/Auto-Tournament/cs2-plugin/releases/download/v1.4.33/MatchZy-1.4.33.zip";
    sha256 = "0v7lin7gzr0q4yj6wcqfa2yp2jcgqzdiygriqrdh3ckykxy36s2v";
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
