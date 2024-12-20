{ pkgs, lib, ... }: {
  dconf = {
    enable = true;
    
    # generated by https://github.com/nix-community/dconf2nix
    settings = with lib.hm.gvariant; {
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
        gap-inner = mkUint32 1;
        gap-outer = mkUint32 1;
	smart-gaps = false;
	tile-by-default = true;
      };

      "org/gnome/shell/app-switcher" = {
        current-workspace-only = true;
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = false;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/shell/keybindings" = {
        toggle-message-tray = [];
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
        minimize = [];
      };      

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kitty";
        name = "Terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
        help = [];
        screensaver = [ "<Super>Escape" ];
      };
    };
  };
}
