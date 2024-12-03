{ pkgs, ... }: {
  imports = [
    ../../home/core.nix

    ../../home/dev
    ../../home/programs
    ../../home/hyprland
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
