{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.ideavim;
in
{
  options.modules.ideavim = {
    enable = mkEnableOption "Enable ideavim configuration";
  };

  config = mkIf cfg.enable {
    home.file.".ideavimrc".source = ./.ideavimrc;
  };
}
