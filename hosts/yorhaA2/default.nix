{ inputs, ... }: {
  imports = [ inputs.private-config.darwinModules.default or { } ];

  modules = {
    fonts.enable = true;
    nix.enable = true;
    work.enable = true;

    programs = {
      enable = true;
      enableMinecraft = true;
    };

    syncthing = {
      enable = true;
      username = "andrew";
    };
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
      ../../users/andrew/home/yorhaA2

      inputs.private-config.homeManagerModules.default
    ];
  };

  homebrew = {
    enable = true;

    onActivation = { autoUpdate = false; };
  };

  time.timeZone = "Europe/Kyiv";

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
}
