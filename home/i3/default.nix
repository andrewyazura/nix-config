{ pkgs, config, ... }: {
  home.file.".config/i3/config".source = ./config;
  home.file.".config/i3/wallpaper.jpg".source = ../../wallpaper.jpg;
  home.file.".config/i3/lock.jpg".source = ../../lock.jpg;
  home.file.".config/i3/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
