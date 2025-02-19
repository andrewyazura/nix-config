{ lib, hostname, ... }: {
  imports = [
    ../../home
    ../../home/ghostty
    ../../home/git
    ../../home/gnome
    ../../home/neovim
    ../../home/programs
    ../../home/ssh
    ../../home/vesktop
    ../../home/work
    ../../home/zsh
  ] ++ lib.optionals (hostname == "r7-x3d") [
    ../../home/cs2
    ../../home/mangohud
  ] ++ lib.optionals (hostname == "ga401") [ ];
}
