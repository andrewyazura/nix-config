{ ... }:
{
  imports = [ ../../common/nix ];

  programs.gnupg.agent.enable = true;
}
