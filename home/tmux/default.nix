{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.tmux;
in
{
  options.modules.tmux = {
    enable = mkEnableOption "Enable tmux configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 0;
      focusEvents = true;
      keyMode = "vi";
      mouse = true;

      extraConfig = ''
        set -g default-command "${pkgs.zsh}/bin/zsh --login"
        set -g default-shell "${pkgs.zsh}/bin/zsh"

        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
        bind -T copy-mode-vi s send-keys -X rectangle-toggle
      '';
    };
  };
}
