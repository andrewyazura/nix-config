{ pkgs, inputs, ... }:
{
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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # hyprland
    hyprlock
    hyprpaper
    hyprshot
    wofi
  ];
}
