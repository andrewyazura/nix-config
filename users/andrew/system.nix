{
  imports = [
    ../../modules/gaming
    ../../modules/hyprland
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs.ssh = {
    startAgent = true;
    agentTimeout = null;
  };
}
