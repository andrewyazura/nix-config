{ lib, config, ... }:
with lib;
let cfg = config.modules.aerospace;
in {
  options.modules.aerospace = {
    enable = mkEnableOption "Enable aerospace configuration";
  };

  config = mkIf cfg.enable {
    services = {
      aerospace = {
        enable = true;
        settings = let modifier = "alt";
        in {
          enable-normalization-flatten-containers = false;
          enable-normalization-opposite-orientation-for-nested-containers =
            false;

          mode.main.binding = {
            "${modifier}-enter" =
              "exec-and-forget /Applications/Ghostty.app/Contents/MacOS/ghostty";

            "${modifier}-h" = "focus left";
            "${modifier}-j" = "focus down";
            "${modifier}-k" = "focus up";
            "${modifier}-l" = "focus right";

            "${modifier}-shift-h" = "move left";
            "${modifier}-shift-j" = "move down";
            "${modifier}-shift-k" = "move up";
            "${modifier}-shift-l" = "move right";

            "${modifier}-ctrl-h" = "move-workspace-to-monitor left";
            "${modifier}-ctrl-j" = "move-workspace-to-monitor down";
            "${modifier}-ctrl-k" = "move-workspace-to-monitor up";
            "${modifier}-ctrl-l" = "move-workspace-to-monitor right";

            "${modifier}-b" = "split horizontal";
            "${modifier}-v" = "split vertical";
            "${modifier}-f" = "fullscreen";

            "${modifier}-s" = "layout v_accordion";
            "${modifier}-w" = "layout h_accordion";
            "${modifier}-e" = "layout tiles horizontal vertical";

            "${modifier}-shift-n" = "layout floating tiling";

            "${modifier}-1" = "workspace 1";
            "${modifier}-2" = "workspace 2";
            "${modifier}-3" = "workspace 3";
            "${modifier}-4" = "workspace 4";
            "${modifier}-5" = "workspace 5";
            "${modifier}-6" = "workspace 6";
            "${modifier}-7" = "workspace 7";
            "${modifier}-8" = "workspace 8";
            "${modifier}-9" = "workspace 9";
            "${modifier}-0" = "workspace 10";

            "${modifier}-shift-1" = "move-node-to-workspace 1";
            "${modifier}-shift-2" = "move-node-to-workspace 2";
            "${modifier}-shift-3" = "move-node-to-workspace 3";
            "${modifier}-shift-4" = "move-node-to-workspace 4";
            "${modifier}-shift-5" = "move-node-to-workspace 5";
            "${modifier}-shift-6" = "move-node-to-workspace 6";
            "${modifier}-shift-7" = "move-node-to-workspace 7";
            "${modifier}-shift-8" = "move-node-to-workspace 8";
            "${modifier}-shift-9" = "move-node-to-workspace 9";
            "${modifier}-shift-0" = "move-node-to-workspace 10";

            "${modifier}-shift-c" = "reload-config";
            "${modifier}-r" = "mode resize";
          };

          mode.resize.binding = {
            h = "resize width -50";
            j = "resize height +50";
            k = "resize height -50";
            l = "resize width +50";

            enter = "mode main";
            esc = "mode main";
          };
        };
      };
    };
  };
}
