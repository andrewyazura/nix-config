{
  config,
  lib,
  pkgs,
  ...
}:
let
  token = config.sops.secrets.agent-github-token.path;
in
{
  users.users.agent = {
    isNormalUser = true;
    shell = pkgs.zsh;
    linger = true;
  };

  sops.secrets.agent-github-token = {
    sopsFile = ../../../secrets/agent-github-token;
    format = "binary";
    owner = "agent";
  };

  home-manager.users.agent = {
    imports = [ ../../../home ];

    home = {
      username = "agent";
      homeDirectory = "/home/agent";
      stateVersion = "25.11";
      packages = with pkgs; [
        gh
        tmux
      ];
    };

    modules = {
      base-packages.enable = true;
      claude = {
        enable = true;
        instances.personal.remoteControl = {
          home = "/home/agent/Documents/claude";
          notes = "/home/agent/Documents/notes";
          nix = "/home/agent/Documents/nix/config";
        };
      };
      git.enable = true;
      zsh.enable = true;
    };

    programs = {
      git = {
        signing.signByDefault = lib.mkForce false;
        settings.credential."https://github.com".helper =
          "!f() { test \"$1\" = get && echo username=x-access-token && echo \"password=$(cat ${token})\"; }; f";
      };
      zsh.envExtra = ''
        export GH_TOKEN="$(cat ${token})"
      '';
    };

    systemd.user.services.claude-remote-control.Service = {
      MemoryMax = "6G";
      CPUQuota = "400%";
    };
  };
}
