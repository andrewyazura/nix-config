{ pkgs, lib, ... }: {
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions;
      [ { package = pop-shell; } ];
  };

  # generated by https://github.com/nix-community/dconf2nix
  # dconf dump / | dconf2nix > home/gnome/dconf.nix
  imports = [ ./dconf.nix ];
}
