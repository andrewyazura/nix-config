{ ... }:
{
  imports = [ ../../common/nix ];

  nix.optimise.automatic = true;

  programs.gnupg.agent.enable = true;

  environment.etc."gnupg/gpg-agent.conf".text = ''
    default-cache-ttl 31536000
    max-cache-ttl 31536000
  '';
}
