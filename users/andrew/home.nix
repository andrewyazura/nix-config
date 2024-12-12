{ pkgs, ... }: {
  imports = [
    ../../home/core.nix
    ../../home/dev
    ../../home/gnome
    ../../home/kitty
    ../../home/mangohud
    ../../home/programs
    ../../home/zsh
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
