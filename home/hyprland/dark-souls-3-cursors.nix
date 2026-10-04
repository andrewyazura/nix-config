{
  bibata-cursors,
  fetchurl,
  runCommand,
  unzip,
  win2xcur,
}:
let
  src = fetchurl {
    url = "https://www.rw-designer.com/cursor-downloadset/dark-souls-iii.zip";
    sha256 = "10zxj38krw93vv7s3c255hmn3qm641l1gxsi2ap6wdax7f5gq1k2";
  };
in
runCommand "dark-souls-3-cursors"
  {
    nativeBuildInputs = [
      unzip
      win2xcur
    ];
  }
  ''
    theme=$out/share/icons/Dark-Souls-III
    mkdir -p $theme
    cp -rP --no-preserve=mode ${bibata-cursors}/share/icons/Bibata-Modern-Classic/cursors $theme/
    printf '[Icon Theme]\nName=Dark-Souls-III\nInherits=hicolor\n' > $theme/index.theme

    unzip -q ${src} -d ds3
    mkdir xc
    win2xcur ds3/*.cur ds3/*.ani -o xc

    cursor() {
      local name=$1
      shift
      for target in "$@"; do
        cp "xc/$name" "$theme/cursors/$target"
      done
    }

    cursor "Dark souls 3" left_ptr
    cursor "Darksign (Link)" hand2
    cursor "Bonfire (Busy)" wait
    cursor "Dark Souls 3 (Working)" left_ptr_watch
    cursor "Dark souls 3 (Alternate)" center_ptr
    cursor "Dark souls 3 (Unavailable)" crossed_circle circle
    cursor "Claymore (handwriting)" pencil
    cursor "Dark souls 3 (Vertical)" sb_v_double_arrow top_side bottom_side
    cursor "Dark souls 3 (Horizontal)" sb_h_double_arrow left_side right_side
    cursor "Dark souls 3 (Diagonal 1)" fd_double_arrow top_right_corner bottom_left_corner
    cursor "Dark souls 3 (Diagonal 2)" bd_double_arrow top_left_corner bottom_right_corner
    cursor "Dark souls 3 (Move)" move
    cursor "Dark souls 3 (Help)" question_arrow
    cursor "Spells (Text)" xterm
    cursor "Sword of Avowal (Precision)" crosshair cross tcross
  ''
