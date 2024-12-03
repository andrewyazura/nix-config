{ ... }: {
  # home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
  # home.file.".config/kitty/current-theme.conf".source = ./current-theme.conf;

  programs.kitty.enable = true;
}
