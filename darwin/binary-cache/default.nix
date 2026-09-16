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
    launchd.daemons.attic-watch-store = {
      serviceConfig = {
        ProgramArguments = [ "${cfg.push.script}" ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardErrorPath = "/var/log/attic-watch-store.log";
      };
    };
  };
}
