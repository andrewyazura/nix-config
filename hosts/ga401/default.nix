{ username, ... }: {
  imports = [
    ../../system

    ./hardware-configuration.nix
  ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    gnome.enable = true;
    networking.enable = true;
    nix.enable = true;
    programs.enable = true;
    work.enable = true;
  };

  home-manager.users.${username}.modules = { gnome.enable = true; };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia.dynamicBoost.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
