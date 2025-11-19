{ inputs, pkgs, ... }:
let
  username = "andrew";
  hostname = "yorhaA2";
in {
  imports = [ ../../darwin inputs.private-config.darwinModules.default ];

  modules = { work.enable = true; };

  nixpkgs.config.allowUnfree = true;
  nix = {
    enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.private-config.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
    ];

    users.${username} = { config, ... }: {
      imports = [ ../../home ];

      modules = {
        btop.enable = true;
        ghostty = {
          enable = true;
          fontSize = 12;
        };
        git.enable = true;
        neovim.enable = true;
        ssh.enable = true;
        work.enable = true;
        zsh.enable = true;
      };

      home = {
        homeDirectory = "/Users/${username}";
        username = username;

        stateVersion = "25.05";
      };

      sops = {
        age.sshKeyPaths =
          [ "/Users/${username}/.ssh/id_ed25519_yorhaA2_nixconfig_1811" ];

        secrets = {
          ssh-config = {
            sopsFile = ../../secrets/ssh-config;
            format = "binary";
          };
          anthropic-api-key = {
            sopsFile = ../../secrets/anthropic-api-key;
            format = "binary";
          };
        };
      };

      programs = {
        git = {
          includes = [{
            condition = "gitdir:/";
            contents = {
              commit.gpgsign = true;
              user.signingkey = "970E41F6C58CCA2A";
            };
          }];
        };

        ssh = {
          includes = [ config.sops.secrets.ssh-config.path ];
          matchBlocks = {
            "github.com" = {
              identityFile = "~/.ssh/id_ed25519_yorhaA2_github_1811";
            };
          };
        };

        zsh = {
          shellAliases = {
            copy = "pbcopy";
            ls = "gls --color=auto";
          };
          initContent = ''
            export LANGUAGE=en_US.UTF-8

            secret_file="${config.sops.secrets.anthropic-api-key.path}"
            export AVANTE_ANTHROPIC_API_KEY=$(cat "$secret_file")
          '';
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ coreutils-prefixed git gnupg ];
    variables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    casks =
      [ "bitwarden" "firefox" "ghostty" "obsidian" "slack" "sol" "spotify" ];
  };

  networking.hostName = hostname;
  networking.computerName = hostname;
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;
  };
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;
    primaryUser = username;
    defaults.smb.NetBIOSName = hostname;

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      swapLeftCtrlAndFn = true;
    };
  };

  time.timeZone = "Europe/Kyiv";
}
