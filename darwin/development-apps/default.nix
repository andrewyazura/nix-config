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
      taps = [
        {
          name = "jetbrains/utils";
          trusted = true;
        }
      ];
      brews = [
        "jetbrains/utils/kotlin-lsp"
      ];

      casks = [
        "bruno"
        "dbeaver-community"
        "headlamp"
        "intellij-idea"
        "lens"
        "mongodb-compass"
        "orbstack"
        "pritunl"
        "proxyman"
        "tuple"
      ];
    };
  };
}
