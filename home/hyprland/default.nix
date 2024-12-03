{ pkgs, ... }: {
  imports = [
    ../kitty
  ];

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   plugins = with pkgs; [
  #     hyprlandPlugins.hy3
  #     hyprlandPlugins.hyprtrails
  #   ];
  #   settings = {
  #     "$mainMod" = "SUPER";
  #
  #     bind = [
  #       "$mainMod, Q, exec, $terminal"
  #       "$mainMod, C, killactive"
  #       "$mainMod, M, exit"
  #       "$mainMod, E, exec, $fileManager"
  #       "$mainMod, V, toggleFloating"
  #       "$mainMod, R, exec, $menu"
  #
  #       "$mainMod, h, movefocus, l"
  #       "$mainMod, j, movefocus, d"
  #       "$mainMod, k, movefocus, u"
  #       "$mainMod, l, movefocus, r"
  #     ] ++ (
  #       # workspaces
  #       # binds $mainMod + [shift +] {1..9} to [move to] workspace {1..9}
  #       builtins.concatLists (builtins.genList (i:
  #           let ws = i + 1;
  #           in [
  #             "$mainMod, code:1${toString i}, workspace, ${toString ws}"
  #             "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
  #           ]
  #         )
  #         9)
  #     );
  #   };
  # };
}
