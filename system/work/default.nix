{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pritunl-client ];

  systemd = {
    packages = [ pkgs.pritunl-client ];
    targets.multi-user.wants = [ "pritunl-client.service" ];
  };
}
