{ pkgs, inputs, ... }: {
  services = {
    xserver = {
      enable = false;
      displayManager = {
        defaultSession = "hyprland";
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };

      xkb = {
        layout = "us,ua";
        variant = "";
        options = "grp:win_space_toggle";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.systemPackages = with pkgs; [ hyprlock wofi ];
}
