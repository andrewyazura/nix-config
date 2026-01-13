{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
