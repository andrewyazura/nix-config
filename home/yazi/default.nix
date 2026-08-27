{ lib, config, ... }:
with lib;
let
  cfg = config.modules.yazi;
  colors = import ../../common/colors.nix;
in
{
  options.modules.yazi = {
    enable = mkEnableOption "Enable yazi configuration";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";

      settings = {
        mgr = {
          show_hidden = true;
        };
      };

      theme = {
        mgr = {
          cwd = {
            fg = colors.accentAlt;
          };

          find_keyword = {
            fg = colors.yellow;
            bold = true;
          };
          find_position = {
            fg = colors.pink;
            bg = "reset";
            bold = true;
          };

          marker_copied = {
            fg = colors.green;
            bg = colors.green;
          };
          marker_cut = {
            fg = colors.red;
            bg = colors.red;
          };
          marker_marked = {
            fg = colors.accentAlt;
            bg = colors.accentAlt;
          };
          marker_selected = {
            fg = colors.yellow;
            bg = colors.yellow;
          };

          count_copied = {
            fg = colors.bg;
            bg = colors.green;
          };
          count_cut = {
            fg = colors.bg;
            bg = colors.red;
          };
          count_selected = {
            fg = colors.bg;
            bg = colors.yellow;
          };

          border_symbol = "│";
          border_style = {
            fg = colors.overlay;
          };
        };

        tabs = {
          active = {
            fg = colors.bg;
            bg = colors.accent;
            bold = true;
          };
          inactive = {
            fg = colors.accent;
            bg = colors.raised;
          };
        };

        mode = {
          normal_main = {
            fg = colors.bg;
            bg = colors.accent;
            bold = true;
          };
          normal_alt = {
            fg = colors.accent;
            bg = colors.raised;
          };
          select_main = {
            fg = colors.bg;
            bg = colors.accentAlt;
            bold = true;
          };
          select_alt = {
            fg = colors.accentAlt;
            bg = colors.raised;
          };
          unset_main = {
            fg = colors.bg;
            bg = colors.yellow;
            bold = true;
          };
          unset_alt = {
            fg = colors.yellow;
            bg = colors.raised;
          };
        };

        status = {
          perm_sep = {
            fg = colors.muted;
          };
          perm_type = {
            fg = colors.accent;
          };
          perm_read = {
            fg = colors.yellow;
          };
          perm_write = {
            fg = colors.red;
          };
          perm_exec = {
            fg = colors.green;
          };

          progress_label = {
            fg = colors.bright;
            bold = true;
          };
          progress_normal = {
            fg = colors.accent;
            bg = colors.overlay;
          };
          progress_error = {
            fg = colors.red;
            bg = colors.overlay;
          };
        };

        pick = {
          border = {
            fg = colors.accent;
          };
          active = {
            fg = colors.pink;
            bold = true;
          };
        };

        input = {
          border = {
            fg = colors.accent;
          };
        };

        cmp = {
          border = {
            fg = colors.accent;
          };
        };

        tasks = {
          border = {
            fg = colors.accent;
          };
          hovered = {
            fg = colors.pink;
            bold = true;
          };
        };

        which = {
          border = {
            fg = colors.accent;
          };
          cand = {
            fg = colors.accentAlt;
          };
          rest = {
            fg = colors.subtle;
          };
          desc = {
            fg = colors.pink;
          };
          separator = "  ";
          separator_style = {
            fg = colors.muted;
          };
        };

        help = {
          on = {
            fg = colors.accentAlt;
          };
          run = {
            fg = colors.pink;
          };
          hovered = {
            reversed = true;
            bold = true;
          };
          footer = {
            fg = colors.text;
            bg = colors.raised;
          };
        };
      };
    };
  };
}
