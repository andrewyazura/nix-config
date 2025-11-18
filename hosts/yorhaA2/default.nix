{ inputs, config, pkgs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];

    users.andrew = {
      home = {
        username = "andrew";
        stateVersion = "25.05";
      };

      sops = {
        age.sshKeyPaths =
          [ "/Users/andrew/.ssh/id_ed25519_yorhaA2_nixconfig_1811" ];
        secrets = {
          ssh-config = {
            sopsFile = ../../../../secrets/ssh-config;
            format = "binary";
          };
          anthropic-api-key = {
            sopsFile = ../../../../secrets/anthropic-api-key;
            format = "binary";
          };
        };
      };

      programs = {
        ssh = {
          includes = [ config.sops.secrets.ssh-config.path ];
          matchBlocks = {
            "github.com" = {
              identityFile = "~/.ssh/id_ed25519_yorhaA2_github_1811";
            };
          };
        };

        zsh = {
          shellAliases = { copy = "pbcopy"; };
          initContent = ''
            secret_file="${config.sops.secrets.anthropic-api-key.path}"
            export AVANTE_ANTHROPIC_API_KEY=$(cat "$secret_file")
          '';
        };
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = { autoUpdate = false; };
  };

  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;
    primaryUser = "andrew";

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
    };
  };

  time.timeZone = "Europe/Kyiv";
}
