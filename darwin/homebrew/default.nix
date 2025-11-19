{ lib, config, ... }:
with lib;
let cfg = config.modules.homebrew;
in {
  options.modules.homebrew = {
    enable = mkEnableOption "Enable homebrew configuration";

    extraCasks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional casks to install";
    };
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false;
        cleanup = "zap";
      };
      casks = cfg.extraCasks;
    };
  };
}
