{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.whisper-cpp;
  proxyPort = 8177;
  serverPort = 8178;

  public = pkgs.runCommand "whisper-public" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
    cp -r ${./public} $out
    chmod u+w $out
    rsvg-convert -w 192 -h 192 ${./public/icon.svg} -o $out/icon-192.png
    rsvg-convert -w 512 -h 512 ${./public/icon.svg} -o $out/icon-512.png
    rsvg-convert -w 512 -h 512 ${./icon-maskable.svg} -o $out/icon-maskable-512.png
  '';

  waitForServer = pkgs.writeShellScript "whisper-server-ready" ''
    until ${lib.getExe pkgs.curl} -sf -o /dev/null http://127.0.0.1:${toString serverPort}/health; do
      sleep 0.1
    done
  '';
in
{
  options.modules.whisper-cpp = {
    enable = lib.mkEnableOption "whisper.cpp dictation page on the tailnet";

    package = lib.mkPackageOption pkgs "whisper-cpp" { };
    model = lib.mkOption {
      type = lib.types.path;
      default = pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-large-v3-turbo.bin";
        hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
      };
      description = "ggml model file for whisper-server";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sockets.whisper-proxy = {
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "127.0.0.1:${toString proxyPort}" ];
    };

    systemd.services = {
      whisper-proxy = {
        requires = [ "whisper-server.service" ];
        after = [ "whisper-server.service" ];
        serviceConfig = {
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:${toString serverPort}";
          DynamicUser = true;
        };
      };

      whisper-server = {
        path = [ pkgs.ffmpeg-headless ];
        environment.MESA_SHADER_CACHE_DIR = "/var/cache/whisper-server";
        unitConfig.StopWhenUnneeded = true;
        serviceConfig = {
          ExecStart = "${lib.getExe' cfg.package "whisper-server"} --host 127.0.0.1 --port ${toString serverPort} --model ${cfg.model} --public ${public} --convert --tmp-dir /tmp -nt";
          ExecStartPost = waitForServer;
          DynamicUser = true;
          CacheDirectory = "whisper-server";
        };
      };

      whisper-tailscale-serve = {
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "tailscaled.service" ];
        serviceConfig.Type = "oneshot";
        script = ''
          ${lib.getExe config.services.tailscale.package} serve --bg --https=443 http://127.0.0.1:${toString proxyPort}
        '';
      };
    };
  };
}
