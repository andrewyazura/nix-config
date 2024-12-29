{ pkgs, ... }: {
  imports = [
    ../../home
    ../../home/dev.nix
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
