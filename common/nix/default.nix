{
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };
}
