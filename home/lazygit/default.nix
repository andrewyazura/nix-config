{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.lazygit;
  colors = import ../../common/colors.nix;
in
{
  options.modules.lazygit = {
    enable = mkEnableOption "Enable lazygit configuration";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;

      settings.gui.theme = {
        activeBorderColor = [
          colors.accent
          "bold"
        ];
        inactiveBorderColor = [ colors.muted ];
        searchingActiveBorderColor = [ colors.yellow ];
        optionsTextColor = [ colors.blue ];
        selectedLineBgColor = [ colors.raised ];
        cherryPickedCommitBgColor = [ colors.overlay ];
        cherryPickedCommitFgColor = [ colors.accent ];
        markedBaseCommitBgColor = [ colors.overlay ];
        markedBaseCommitFgColor = [ colors.yellow ];
        unstagedChangesColor = [ colors.red ];
        defaultFgColor = [ colors.text ];
      };
    };
  };
}
