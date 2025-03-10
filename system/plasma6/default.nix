{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.plasma6;
  askpass = pkgs.kdePackages.ksshaskpass;
in {
  options.modules.plasma6 = {
    enable = mkEnableOption "Enable KDE Plasma 6 configuration";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager = {
        defaultSession = "plasma";
        sddm.enable = true;
      };

      desktopManager.plasma6.enable = true;
    };

    programs.ssh = {
      startAgent = true;
      enableAskPassword = true;
      askPassword = "${askpass}/bin/ksshaskpass";
    };

    environment = {
      systemPackages = [ askpass ];
      sessionVariables = { SSH_ASKPASS_REQUIRE = "prefer"; };
    };

    hardware.bluetooth.enable = true;
  };
}
