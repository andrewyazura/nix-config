{ pkgs, config, ... }: {
  home.file.".config/picom/picom.conf".source = ./picom.conf;
}
