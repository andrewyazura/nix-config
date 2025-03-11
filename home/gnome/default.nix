{ lib, config, ... }:
with lib;
let cfg = config.modules.gnome;
in {
  # generated by https://github.com/nix-community/dconf2nix
  # dconf dump / | dconf2nix > home/gnome/dconf.nix
  imports = [ ./dconf.nix ];

  options.modules.gnome = {
    enable = mkEnableOption "Enable GNOME configuration";
  };

  config = mkIf cfg.enable {
    programs.gnome-shell = {
      enable = true;
      # extensions = with pkgs.gnomeExtensions; [{ package = pop-shell; }];
    };
  };
}
