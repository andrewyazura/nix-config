{ pkgs, ... }: {
  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
