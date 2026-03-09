{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.tmux;
  catppuccinFlavor = config.catppuccin.flavor;
in
{
  options.modules.tmux = {
    enable = mkEnableOption "Enable tmux configuration";
    showBattery = mkEnableOption "Show battery status in tmux status bar";
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

      plugins =
        with pkgs.tmuxPlugins;
        [
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavor "${catppuccinFlavor}"
              set -g @catppuccin_window_status_style "basic"

              set -g @catppuccin_window_number "#I"
              set -g @catppuccin_window_text " #W"

              set -g @catppuccin_window_current_number "#I"
              set -g @catppuccin_window_current_text " #W"

              set -g @catppuccin_status_left_separator "█"
              set -g @catppuccin_status_right_separator "█"

              set -g status-left ""
              set -g status-right "#{E:@catppuccin_status_session}"
              set -ag status-right "#{E:@catppuccin_status_uptime}"
            '';
          }
          {
            plugin = cpu;
            extraConfig = ''
              set -agF status-right "#{E:@catppuccin_status_cpu}"
            '';
          }
          resurrect
        ]
        ++ optional cfg.showBattery {
          plugin = battery;
          extraConfig = ''
            set -agF status-right "#{E:@catppuccin_status_battery}"
          '';
        };

      extraConfig = ''
        set -g default-command "${pkgs.zsh}/bin/zsh --login"
        set -g default-shell "${pkgs.zsh}/bin/zsh"

        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        set -g set-titles on
        set -g set-titles-string "#{pane_title}"

        set -g status-left-length 150
        set -g status-right-length 150

        bind р select-pane -L # h
        bind о select-pane -L # j
        bind л select-pane -U # k
        bind д select-pane -R # l

        bind Ж command-prompt # ;
        bind в detach-client # d
        bind з previous-window # p
        bind с new-window # c
        bind т next-window # n
        bind і choose-tree -Zs # s

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
