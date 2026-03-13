{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.difftastic;
in
{
  options.modules.difftastic = {
    enable = mkEnableOption "Enable difftastic configuration";
    enableLazygit = mkOption {
      type = types.bool;
      default = true;
      description = "Use difftastic in lazygit";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.difftastic = {
        enable = true;
        git = {
          enable = true;
          diffToolMode = true;
        };
      };
    })

    (mkIf cfg.enableLazygit {
      programs.lazygit.settings.git.pagers = [
        {
          externalDiffCommand = "difft --color=always";
        }
      ];
    })
  ];
}
