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
  cleanResurrectBin = pkgs.runCommand "clean-resurrect" { nativeBuildInputs = [ pkgs.zig ]; } ''
    export XDG_CACHE_HOME=$(mktemp -d)
    zig build-exe ${./clean-resurrect.zig} -O ReleaseSafe -femit-bin=clean-resurrect
    mkdir -p $out/bin/
    mv clean-resurrect $out/bin/
  '';
in
{
  options.modules.tmux = {
    enable = mkEnableOption "Enable tmux configuration";
    showBattery = mkEnableOption "Show battery status in tmux status bar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
      jq
      ripgrep
    ];

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

              set -g @catppuccin_window_number "#I"
              set -g @catppuccin_window_text " #W"

              set -g @catppuccin_window_current_number "#I"
              set -g @catppuccin_window_current_text " #W"

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
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-dir '~/.tmux/resurrect'
              set -g @resurrect-processes 'nvim lazygit pi claude gemini'
              set -g @resurrect-hook-post-save-all '${cleanResurrectBin}/bin/clean-resurrect'
            '';
          }
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

        set -g extended-keys on
        set -g extended-keys-format csi-u

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

        bind U run-shell "${pkgs.zsh}/bin/zsh -ic 'paste | jq -r . | copy'"

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
