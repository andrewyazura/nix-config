{ pkgs, username, ... }: {
  imports = [ ../../system ];

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
