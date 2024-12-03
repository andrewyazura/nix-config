{ pkgs, ... }: {
  imports = [
    ../../home/core.nix

    ../../home/dev
    ../../home/programs
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
