{ lib, config, ... }:
with lib;
let
  cfg = config.modules.gui-apps.productivity;
in
{
  options.modules.gui-apps.productivity = {
    enable = mkEnableOption "Enable productivity GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "claude"
      "obsidian"
    ];
  };
}
