{ pkgs, ... }: {
  imports = [
    ../../home/core.nix

    ../../home/dev
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
