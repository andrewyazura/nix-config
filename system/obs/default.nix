{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.obs;
in {
  options.modules.obs = { enable = mkEnableOption "Enable OBS configuration"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        (wrapOBS {
          plugins = with obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        })
      ];

    boot.extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };
}
