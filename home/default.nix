{ username, ... }: {
  imports = [
    ./cs2
    ./ghostty
    ./git
    ./gnome
    ./hyprland
    ./i3
    ./mangohud
    ./neovim
    ./polybar
    ./ssh
    ./sway
    ./vesktop
    ./waybar
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
