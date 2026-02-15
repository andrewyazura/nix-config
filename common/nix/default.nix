{
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://cache.andrewyazura.com/main?priority=30"
        "https://cache.nixos.org?priority=40"
        "https://nix-community.cachix.org?priority=50"
        "https://ghostty.cachix.org?priority=60"
      ];

      trusted-public-keys = [
        "main:T8v5SdwjNhvJowlHJFFNB1O9PbXyLrZ+vRKe7OWGCa8="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];

      netrc-file = "/run/secrets/netrc";

      connect-timeout = 5;
      fallback = true;
      http2 = true;
      warn-dirty = false;
    };
  };
}
