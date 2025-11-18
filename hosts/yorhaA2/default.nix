{ inputs, ... }: {
  home-manager.users.andrew = {
    imports =
      [ ../../home ../../users/andrew/home ../../users/andrew/home/yorhaA2 ];
  };

  homebrew = {
    enable = true;
    onActivation = { autoUpdate = false; };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inputs;
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  time.timeZone = "Europe/Kyiv";
}
