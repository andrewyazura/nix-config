{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.vesktop;
in
{
  options.modules.vesktop = {
    enable = mkEnableOption "Enable Vesktop configuration";
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;

      package = pkgs.vesktop.overrideAttrs (prev: {
        postFixup = prev.postFixup + ''
          wrapProgram $out/bin/vesktop \
            --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment"
        '';
      });

      mutableSettings = true;
      settings = {
        arRPC = false;
        audio.workaround = false;
        discordBranch = "stable";
        hardwareAcceleration = true;
        minimizeToTray = false;
        splashBackground = "rgb(0, 0, 0)";
        splashColor = "rgb(220, 220, 223)";
      };

      vencord = {
        mutableSettings = true;
        settings.plugins = {
          FakeNitro.enabled = true;
          VolumeBooster.enabled = true;
          WebScreenShareFixes.enabled = true;
        };
      };
    };
  };
}
