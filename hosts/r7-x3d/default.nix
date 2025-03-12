{ username, ... }: {
  imports = [
    ../../system

    ./hardware-configuration.nix
  ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    gaming.enable = true;
    guitar.enable = true;
    logitech-g920.enable = true;
    minegrub.enable = true;
    networking.enable = true;
    nix.enable = true;
    obs.enable = true;
    programs.enable = true;
    sway.enable = true;
    wooting.enable = true;
    work.enable = true;
  };

  home-manager.users.${username}.modules = {
    cs2.enable = true;
    mangohud.enable = true;
    sway.enable = true;
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 10;
      gfxmodeEfi = "3840x2160";
    };

    efi.canTouchEfiVariables = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
