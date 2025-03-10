{ pkgs, lib, hostname, ... }: {
  imports = [ ../../system ]
    ++ lib.optionals (hostname == "ga401") [ ../../home/work ];

  modules = {
    fonts.enable = true;
    programs.enable = true;
  };

  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
