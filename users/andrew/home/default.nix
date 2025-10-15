{ config, ... }:
let username = "andrew";
in {
  modules = {
    btop.enable = true;
    ghostty.enable = true;
    git.enable = true;
    neovim.enable = true;
    ssh.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

  sops = {
    secrets.ssh_config = {
      sopsFile = ../../../secrets/ssh_config;
      format = "binary";
    };
  };

  programs.ssh.includes = [ config.sops.secrets.ssh_config.path ];
}
