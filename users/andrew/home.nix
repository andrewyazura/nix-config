{ lib, hostname, ... }: {
  imports = [
    ../../home
    ../../home/ghostty
    ../../home/git
    ../../home/neovim
    ../../home/ssh
    ../../home/vesktop
    ../../home/zsh
  ] ++ lib.optionals (hostname == "r7-x3d") [
    ../../home/cs2
    ../../home/mangohud
  ] ++ lib.optionals (hostname == "ga401") [ ../../home/gnome ../../home/work ];
}
