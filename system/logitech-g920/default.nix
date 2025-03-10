{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.logitech-g920;
in {
  options.modules.logitech-g920 = {
    enable = mkEnableOption "Enable Logitech G920 configuration";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ usb-modeswitch ];
      etc."usb_modeswitch.d/046d:c261".source = ./modeswitch;
    };

    # alternatively, use this command
    # `sudo usb_modeswitch -v 046d -p c261 -c system/logitech-g920/modeswitch`
  };
}
