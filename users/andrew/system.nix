{ pkgs, lib, hostname, ... }: {
  imports = [ ../../system/programs ../../system/wooting ../../system/work ]
    ++ lib.optionals (hostname == "r7-x3d") [
      ../../system/gaming
      ../../system/logitech-g920
      ../../system/obs
    ];

  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
