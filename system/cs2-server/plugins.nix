{
  pkgs,
  lib,
  stdenv,
}:

let
  readyupVersion = "0.2.33";

  readyupComponents = {
    core = "0cqv79acpgzbfdyxj72mmk88p6fby47c7d8n0a9jap2jv0cvgzj0";
    essentials-plugin = "1yb2glxxh2nzjyz2mlqv15rjzv8axif25n46b50vi6knk6qczdp7";
    match = "11ls05rnssg62kbj0mzng84jns1azscvpv8i7ma51nsp09p2lpz9";
    fleet = "1s6bzjna6p80chqclrwwxj55zjl0wgscb4mjbdxb8p4yamwz3id0";
    practice = "1vzlksa60sm8qpyrx6k92p8mpsn5fqb7diaz8rjxmcxk119bwf5b";
    mapvote = "1qkd2n168pn1ci4rzhb27r5g1lp58qh1dib8rvb8i2lbj9fwp69p";
    retakes = "00g611x039bmsgkxkj2xsgq8ibsdbw233hw6mmpl4dg04vsqg93f";
    deathmatch = "0yxi0bjla2mbg128ykv7mflkcy9p3j96pxixqfa87hrgrhl13c6c";
    movement = "0vwra68gp4pazmw2c9ikx9ng47zidwz797hgr79027p3zsx0aa28";
  };

  readyup = lib.mapAttrsToList (
    name: sha256:
    pkgs.fetchurl {
      url = "https://github.com/Auto-Tournament/ready-up/releases/download/v${readyupVersion}/ready-up-${name}-${readyupVersion}-linuxsteamrt64.zip";
      inherit sha256;
    }
  ) readyupComponents;

in
stdenv.mkDerivation {
  pname = "cs2-plugins";
  version = "1.0";

  nativeBuildInputs = [
    pkgs.unzip
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    ${lib.concatMapStrings (zip: "unzip -q ${zip} -d $out\n") readyup}
  '';
}
