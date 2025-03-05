{ username, ... }: {
  programs = {
    firefox.enable = true;
    chromium.enable = true;
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
