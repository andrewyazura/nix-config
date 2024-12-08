{
  imports = [
    ../../system/gaming
    ../../system/programs
  ];

  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Yatsura";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
