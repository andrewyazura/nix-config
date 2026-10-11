{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.logitech-pro-x-2;
in
{
  options.modules.logitech-pro-x-2 = {
    enable = mkEnableOption "Enable Logitech PRO X 2 configuration";
  };

  config = mkIf cfg.enable {
    services.pipewire.wireplumber.extraConfig."51-logitech-pro-x-2"."monitor.alsa.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.usb-Logitech_PRO_X_2_LIGHTSPEED_0000000000000000-00"; } ];
        actions.update-props."api.alsa.soft-mixer" = true;
      }
    ];

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="sound", KERNEL=="controlC*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0af7", RUN+="${pkgs.alsa-utils}/bin/amixer -c %n -q sset PCM 100%%"
    '';
  };
}
