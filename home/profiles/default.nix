{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.profiles;
in
{
  options.modules.profiles = {
    base.enable = mkEnableOption "Base CLI tools profile";
    development.enable = mkEnableOption "Development environment profile";
    desktop.enable = mkEnableOption "Desktop applications profile";
    ai-tools.enable = mkEnableOption "AI coding tools profile";
  };

  config = mkMerge [
    (mkIf cfg.base.enable {
      modules = {
        btop.enable = mkDefault true;
        direnv.enable = mkDefault true;
        git.enable = mkDefault true;
        base-packages.enable = mkDefault true;
        ssh.enable = mkDefault true;
        tmux.enable = mkDefault true;
        zsh.enable = mkDefault true;
      };
    })

    (mkIf cfg.development.enable {
      modules = {
        neovim.enable = mkDefault true;
        dev-packages.enable = mkDefault true;
      };
    })

    (mkIf cfg.desktop.enable {
      modules = {
        ghostty.enable = mkDefault true;
        media-packages.enable = mkDefault true;
        spotify.enable = mkDefault true;
        theme.enable = mkDefault true;
        yazi.enable = mkDefault true;
      };
    })

    (mkIf cfg.ai-tools.enable {
      modules = {
        claude.enable = mkDefault true;
        mcp.enable = mkDefault true;
        opencode.enable = mkDefault true;
      };
    })
  ];
}
