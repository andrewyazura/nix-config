{ pkgs, config, ... }: {
  home.file.".config/i3/config".source = ./config;
  home.file.".config/i3/wallpapers" = {
    source = ../../wallpapers;
    recursive = true;
  };
  home.file.".config/i3/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
