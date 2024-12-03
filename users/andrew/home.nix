{ pkgs, ... }: {
  imports = [
    ../../home/core.nix

    ../../home/dev
    ../../home/hyprland
    ../../home/kitty
    ../../home/programs
  ];

  programs.git = {
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };
}
