{ pkgs, ... }: {
  dconf = {
    enable = true;
    settings = {
      # https://github.com/nix-community/dconf2nix
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
      	  pop-shell.extensionUuid
        ];
      };

      "org/gnome/shell/extensions/pop-shell" = {
        active-hint = false;
	active-hint-border-radius="uint32 0";
	fullscreen-launcher = true;
	gap-inner = "uint32 1";
	gap-outer = "uint32 1";
	smart-gaps = false;
	tile-by-default = true;
      };

      "org/gnome/shell/app-switcher" = {
        current-workspace-only = true;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      "org/gnome/shell/keybindings" = {
        toggle-message-tray = [];
      };

      "org/gnome/desktop/wm/keybindings" = {
        minimize = [];
      };
      
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };
    };
  };
}
