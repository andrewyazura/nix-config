{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.binary-cache;
in
{
  config = mkIf (cfg.enable && cfg.push.enable) {
    systemd.services.attic-watch-store = {
      description = "Push new store paths to the Attic binary cache";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "nix-daemon.service"
      ];

      serviceConfig = {
        ExecStart = cfg.push.script;
        Restart = "on-failure";
        RestartSec = 10;
        RuntimeDirectory = "attic-watch-store";
        RuntimeDirectoryMode = "0700";
      };
    };
  };
}
