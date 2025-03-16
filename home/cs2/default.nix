{ lib, config, ... }:
with lib;
let cfg = config.modules.cs2;
in {
  options.modules.cs2 = { enable = mkEnableOption "Enable CS2 configuration"; };

  config = mkIf cfg.enable {
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg".source =
      ./autoexec.cfg;
    # -refresh 144 -high -fullscreen -forcepreload 1 -threads 9 +mat_disable_fancy_blending 1 -mat_queue_mode 2 +engine_low_latency_sleep_after_client_tick
  };
}
