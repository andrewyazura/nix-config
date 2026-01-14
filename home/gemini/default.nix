{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.gemini;
in
{
  options.modules.gemini = {
    enable = mkEnableOption "Enable gemini configuration";
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;

      settings = {
        autoAccept = true;
        preferredEditor = "nvim";
        vimMode = true;
      };
    };
  };
}
