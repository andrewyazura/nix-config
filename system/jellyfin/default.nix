{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.jellyfin;
in
{
  options.modules.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;

      hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/renderD128";
      };

      transcoding = {
        enableHardwareEncoding = true;
        hardwareDecodingCodecs = {
          h264 = true;
          hevc = true;
          hevc10bit = true;
          vp9 = true;
          av1 = true;
        };
        hardwareEncodingCodecs = {
          hevc = true;
          av1 = true;
        };
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8096 ];
  };
}
