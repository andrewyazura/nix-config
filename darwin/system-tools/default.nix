{ lib, config, ... }:
with lib;
let
  cfg = config.modules.system-tools;
in
{
  options.modules.system-tools = {
    enable = mkEnableOption "Enable macOS-specific system utility applications";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "focusrite-control-2"

      {
        name = "mos";
        args = {
          # Suppress quarantine warning for this app
          no_quarantine = true;
        };
      }
    ];
  };
}
