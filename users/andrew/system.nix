{ pkgs, lib, hostname, ... }: {
  imports = [ ../../system/programs ] ++ lib.optionals (hostname == "r7-x3d") [
    ../../system/gaming
    ../../system/logitech-g920
    ../../system/wooting
  ] ++ lib.optionals (hostname == "ga401") [ ../../home/work ];

  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
