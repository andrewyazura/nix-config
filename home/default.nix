{ username, ... }: {
  imports = [
    ./cs2
    ./ghostty
    ./git
    ./gnome
    ./hyprland
    ./mangohud
    ./neovim
    ./ssh
    ./sway
    ./vesktop
    ./work
    ./zsh
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
