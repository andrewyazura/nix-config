{ lib, config, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.work;
in {
  options.modules.work = {
    enable = mkEnableOption "Enable work configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      code-cursor
      pritunl-client 
      slack
      vscode
      zed-editor
    ];

    systemd = {
      packages = [ pkgs.pritunl-client ];
      targets = { multi-user = { wants = [ "pritunl-client.service" ]; }; };
    };
  };
}
