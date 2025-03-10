{ pkgs, ... }: {
  imports = [ ../../system ../../system/home-manager ];

  modules = {
    fonts.enable = true;
    programs.enable = true;
    work.enable = true;
  };

  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
