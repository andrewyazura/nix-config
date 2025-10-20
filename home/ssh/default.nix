{ lib, config, ... }:
with lib;
let cfg = config.modules.ssh;
in {
  options.modules.ssh = { enable = mkEnableOption "Enable SSH configuration"; };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          identitiesOnly = true;
        };

        "github.com" = {
          hostname = "github.com";
          user = "git";
        };
      };
    };

    services.ssh-agent.enable = true;
  };
}
