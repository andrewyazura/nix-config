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
    homebrew = {
      taps = [ "jetbrains/utils" ];
      brews = [ "jetbrains/utils/kotlin-lsp" ];

      casks = [
        "bruno"
        "headlamp" # xattr -dr com.apple.quarantine /Applications/Headlamp.app
        "intellij-idea"
        "zed"
      ];
    };
  };
}
