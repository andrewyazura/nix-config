{ pkgs, ... }: {
  imports = [
    ../../home
    ../../home/cs2
    ../../home/ghostty
    ../../home/git
    ../../home/gnome
    ../../home/kitty
    ../../home/mangohud
    ../../home/neovim
    ../../home/programs
    ../../home/zsh
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
