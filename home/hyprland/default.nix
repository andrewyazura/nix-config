{ pkgs, hyprland, hyprland-plugins, ... }: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = let
    system = pkgs.stdenv.hostPlatform.system;
  in {
    enable = true;
    package = hyprland.packages.${system}.hyprland;
    plugins = with hyprland-plugins; [
      packages.${system}.borders-plus-plus
      packages.${system}.hyprbars
      packages.${system}.hyprtrails
    ];
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
      ];
    };
  };
}
