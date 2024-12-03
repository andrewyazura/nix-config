{ pkgs, hyprland, hyprland-plugins, ... }: {
  imports = [
    ../kitty
  ];

  wayland.windowManager.hyprland = let
    system = pkgs.stdenv.hostPlatform.system;
  in {
    enable = true;
    package = hyprland.packages.${system}.hyprland;
    plugins = with hyprland-plugins; [
      # packages.${system}.borders-plus-plus
      packages.${system}.hyprbars
      # packages.${system}.hyprtrails
    ];
    extraConfig = ''
      ${builtins.readFile ./hyprland.conf}
    '';
  };
}
