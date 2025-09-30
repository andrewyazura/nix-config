{ lib, config, ... }:
with lib;
let cfg = config.modules.ssh;
in {
  options.modules.ssh = { enable = mkEnableOption "Enable SSH configuration"; };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };

      extraConfig = ''
        IdentityFile ~/.ssh/id_ed25519_proton
        IdentityFile ~/.ssh/id_ed25519_spacedevlab
        AddKeysToAgent yes
        SetEnv TERM=xterm-256color
      '';
    };
  };
}
