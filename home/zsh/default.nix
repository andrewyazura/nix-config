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
        gcm = "git commit";
        gpl = "git pull";
        gplr = "git pull --rebase";
        gplra = "git pull --rebase --autostash";
        gps = "git push";
        grb = "git rebase";
        gst = "git status";
        gw = "git worktree";
      };
    };
  };
}
