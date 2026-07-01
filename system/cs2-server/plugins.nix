{
  pkgs,
  lib,
  stdenv,
}:

let
  metamod = pkgs.fetchurl {
    url = "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1402-linux.tar.gz";
    sha256 = "0bhymj7dnjfa7rcn634q5bkqdn07741fz2398l2djgs79k549na7";
  };

  cssharp = pkgs.fetchurl {
    url = "https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v1.0.370/counterstrikesharp-with-runtime-linux-1.0.370.zip";
    sha256 = "0ydbwh966nsv05x8dqyclamb0r5gy4aanppwpigqfmbx8qr6cqpf";
  };

  matchzy = pkgs.fetchurl {
    url = "https://github.com/shobhit-pathak/MatchZy/releases/download/0.8.15/MatchZy-0.8.15.zip";
    sha256 = "0mvbb21d33lqya9v8v1pkn2x6il5hjkx00k0vlalky2xavbmana2";
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
