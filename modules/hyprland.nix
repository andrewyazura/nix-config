{ pkgs, lib, inputs, ... }: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.systemPackages = with pkgs; [ wofi ];
}
