{ config, lib, ... }:
{
  modules = {
    claude.enable = true;
    gemini.enable = true;
    ideavim.enable = true;
    mcp.enable = true;
    opencode.enable = true;
    work.enable = true;

    packages = {
      media.enable = true;
    };
  };
  home.stateVersion = "25.05";

  launchd.agents.sops-nix.config.EnvironmentVariables.PATH =
    lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";

  sops = {
    age.sshKeyPaths = [ "/Users/andrew/.ssh/id_ed25519_yorhaA2_nixconfig_3011" ];

    secrets = {
      ssh-config = {
        sopsFile = ../../../../secrets/ssh-config;
        format = "binary";
      };
    };
  };

  programs = {
    ssh = {
      includes = [ config.sops.secrets.ssh-config.path ];
      matchBlocks = {
        "bunker" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_bunker_1701";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_github_3011";
        };
        "proxmoxnix" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_proxmoxnix_0112";
        };
      };
    };

    zsh = {
      shellAliases = {
        copy = "pbcopy";
        ls = "ls --color=auto";
      };
      initContent = ''
        export LANGUAGE=en_US.UTF-8

        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
