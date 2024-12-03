{ pkgs, ... }: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = let
    system = pkgs.stdenv.hostPlatform.system;
  in {
    enable = true;
    # package = inputs.hyprland.packages.${system}.hyprland;
    # plugins = [
    #   inputs.hyprland-plugins.packages.${system}.borders-plus-plus
    #   inputs.hyprland-plugins.packages.${system}.hy3
    #   inputs.hyprland-plugins.packages.${system}.hyprbars
    #   inputs.hyprland-plugins.packages.${system}.hyprtrails
    # ];
  };
}
