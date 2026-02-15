{ lib, config, ... }:
with lib;
let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = mkEnableOption "Enable gaming GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "steam"
      "prismlauncher"
    ];
  };
}
