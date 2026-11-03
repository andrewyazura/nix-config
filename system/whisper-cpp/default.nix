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

  dictateScript = pkgs.writeShellApplication {
    name = "dictate";
    text = (builtins.readFile ./dictate.sh);
    runtimeInputs = with pkgs; [
      cfg.package
      libnotify
      pipewire
      wl-clipboard
    ];
    runtimeEnv = {
      WHISPER_CPP_MODEL = "${cfg.model}";
    }
    // lib.optionalAttrs (cfg.source != null) {
      DICTATE_SOURCE = cfg.source;
    };
  };

  waitForServer = pkgs.writeShellScript "whisper-server-ready" ''
    until ${lib.getExe pkgs.curl} -sf -o /dev/null http://127.0.0.1:${toString serverPort}/health; do
      sleep 0.1
    done
  '';
in
{
  options.modules.whisper-cpp = {
    enable = lib.mkEnableOption "whisper-cpp";

    package = lib.mkPackageOption pkgs "whisper-cpp" { };
    model = lib.mkOption {
      type = lib.types.path;
      default = pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-large-v3-turbo.bin";
        hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
      };
      description = "ggml model file for whisper-cli and whisper-server";
    };
    source = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "PipeWire node.name of the source to record from; null uses the default source";
    };

    server.enable = lib.mkEnableOption "whisper.cpp dictation page on the tailnet";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ dictateScript ];
    })

    (lib.mkIf cfg.server.enable {
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
            ExecStart = "${lib.getExe' cfg.package "whisper-server"} --host 127.0.0.1 --port ${toString serverPort} --model ${cfg.model} --public ${./public} --convert --tmp-dir /tmp -nt";
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
    })
  ];
}
