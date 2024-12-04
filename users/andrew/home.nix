{ pkgs, ... }: {
  imports = [
    ../../home/core.nix

    ../../home/dev
    ../../home/kitty
    ../../home/programs
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
