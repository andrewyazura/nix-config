{ pkgs, config, username, ... }: {
  programs = {
    firefox.enable = true;
    chromium.enable = true;
  };
}
