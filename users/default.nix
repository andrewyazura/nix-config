{ pkgs, username, ... }: {
  programs.zsh.enable = true;

  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = { users.${username} = import ./${username}/home.nix; };
}
