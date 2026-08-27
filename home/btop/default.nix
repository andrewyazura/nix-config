{ lib, config, ... }:
with lib;
let
  cfg = config.modules.btop;
  colors = import ../../common/colors.nix;
in
{
  options.modules.btop = {
    enable = mkEnableOption "Enable btop configuration";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "oled-carbon";
        theme_background = true;
        vim_keys = true;
      };
    };

    xdg.configFile."btop/themes/oled-carbon.theme".text = ''
      theme[main_bg]="${colors.bg}"
      theme[main_fg]="${colors.text}"
      theme[title]="${colors.bright}"
      theme[hi_fg]="${colors.accent}"
      theme[selected_bg]="${colors.overlay}"
      theme[selected_fg]="${colors.accent}"
      theme[inactive_fg]="${colors.muted}"
      theme[graph_text]="${colors.subtle}"
      theme[meter_bg]="${colors.overlay}"
      theme[proc_misc]="${colors.accentAlt}"

      theme[cpu_box]="${colors.overlay}"
      theme[mem_box]="${colors.overlay}"
      theme[net_box]="${colors.overlay}"
      theme[proc_box]="${colors.overlay}"
      theme[div_line]="${colors.overlay}"

      theme[temp_start]="${colors.green}"
      theme[temp_mid]="${colors.yellow}"
      theme[temp_end]="${colors.red}"

      theme[cpu_start]="${colors.accentAlt}"
      theme[cpu_mid]="${colors.blue}"
      theme[cpu_end]="${colors.accent}"

      theme[free_start]="${colors.teal}"
      theme[free_mid]="${colors.accentAlt}"
      theme[free_end]="${colors.blue}"

      theme[cached_start]="${colors.blue}"
      theme[cached_mid]="${colors.indigo}"
      theme[cached_end]="${colors.accent}"

      theme[available_start]="${colors.yellow}"
      theme[available_mid]="${colors.pink}"
      theme[available_end]="${colors.red}"

      theme[used_start]="${colors.green}"
      theme[used_mid]="${colors.yellow}"
      theme[used_end]="${colors.red}"

      theme[download_start]="${colors.teal}"
      theme[download_mid]="${colors.accentAlt}"
      theme[download_end]="${colors.blue}"

      theme[upload_start]="${colors.pink}"
      theme[upload_mid]="${colors.accent}"
      theme[upload_end]="${colors.indigo}"

      theme[process_start]="${colors.accentAlt}"
      theme[process_mid]="${colors.blue}"
      theme[process_end]="${colors.accent}"
    '';
  };
}
