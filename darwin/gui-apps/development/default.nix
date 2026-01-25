{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.gui-apps.development;
in
{
  options.modules.gui-apps.development = {
    enable = mkEnableOption "Enable development GUI applications";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "antigravity"
      "intellij-idea"
      "visual-studio-code"
    ];
  };
}
