{ pkgs, config, ... }: {
  home.file.".config/polybar/config.ini".source = ./config.ini;
}
