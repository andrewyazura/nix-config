{
  bibata-cursors,
  fetchurl,
  runCommand,
}:
let
  src = fetchurl {
    url = "https://github.com/Beinsezii/NieR-Cursors/releases/download/2020-08-25/NieR_Cursors_2020-08-25.tar.xz";
    sha256 = "097kj99a16f60fzzh9k94lgjkvj3i1awgpgxwmyf43l71zy1ysaa";
  };
in
runCommand "nier-cursors" { } ''
  theme=$out/share/icons/NieR-Cursors
  mkdir -p $theme
  cp -rP --no-preserve=mode ${bibata-cursors}/share/icons/Bibata-Modern-Classic/cursors $theme/
  printf '[Icon Theme]\nName=NieR-Cursors\nInherits=hicolor\n' > $theme/index.theme

  tar xJf ${src}
  cp -r --no-preserve=mode nier_cursors/nier $theme/
  cp -P --remove-destination nier_cursors/cursors/* $theme/cursors/
''
