{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.development-apps;
in
{
  options.modules.development-apps = {
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
