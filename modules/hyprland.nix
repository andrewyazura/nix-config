{ pkgs, inputs, ... }: {
  services = {
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    xserver.enable = false;
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.systemPackages = with pkgs; [ hyprlock hyprpaper wofi ];
}
