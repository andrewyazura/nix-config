{ pkgs, ... }: {
  imports = [
    ../../system/gaming
    ../../system/logitech-g920
    ../../system/programs
    ../../system/wooting
    ../../system/work
  ];

  programs.zsh.enable = true;

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
