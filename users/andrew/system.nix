{ pkgs, ... }:
let username = "andrew";
in {
  imports = [ ../../system ];

  programs.zsh.enable = true;

  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = import ../../common/ssh-keys.nix;
  };

  home-manager = {
    users.${username} = import ../../users/${username}/home.nix;
  };
}
