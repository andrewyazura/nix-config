{ ... }:
{
  imports = [ ../../common/nix ];

  nix.optimise.automatic = true;

  programs.gnupg.agent.enable = true;
}
