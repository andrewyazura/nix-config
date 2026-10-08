{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.sunshine;
in
{
  options.modules.sunshine = {
    enable = mkEnableOption "Enable Sunshine, a game stream host for Moonlight";
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
      settings = {
        capture = "kms";
        csrf_allowed_origins = "https://100.125.181.10:47990";
      };
    };

    services.udev.extraRules = ''
      KERNEL=="uhid", TAG+="uaccess"
    '';
  };
}
