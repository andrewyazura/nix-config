{ config, ... }:
{
  modules = {
    cs2.enable = true;
    ghostty.fontSize = 10;
    obs.enable = true;
    profiles = {
      development.enable = true;
      desktop.enable = true;
      ai-tools.enable = true;
    };
    vesktop.enable = true;
    video-editing.enable = true;
  };
  home.stateVersion = "24.11";

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha2b_nixconfig_1510" ];
    secrets = {
      ssh-config = {
        sopsFile = ../../../../secrets/ssh-config;
        format = "binary";
      };
      google-calendar-env = {
        sopsFile = ../../../../secrets/google-calendar-env;
        format = "binary";
      };
    };
  };

  home.sessionVariables.GOOGLE_CALENDAR_ENV = config.sops.secrets.google-calendar-env.path;

  programs = {
    ssh = {
      includes = [ config.sops.secrets.ssh-config.path ];
      settings = {
        "bunker" = {
          identityFile = "~/.ssh/id_ed25519_yorha2b_bunker_1801";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorha2b_github_1110";
        };
      };
    };

    zsh = {
      shellAliases = {
        copy = "wl-copy";
        paste = "wl-paste";
      };
    };
  };
}
