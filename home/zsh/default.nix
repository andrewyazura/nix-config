{ lib, config, ... }:
with lib;
let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh = {
    enable = mkEnableOption "Enable zsh configuration";
  };

  config = mkIf cfg.enable {
    catppuccin.zsh-syntax-highlighting.enable = false;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "vi-mode"
        ];
      };

      shellAliases = {
        ll = "ls -ahl --group-directories-first";

        ga = "git add";
        gc = "git commit";
        gl = "git log";
        gp = "git pull";
        gP = "git push";
        gr = "git rebase";
        gs = "git status";
        gw = "git worktree";
      };
    };
  };
}
