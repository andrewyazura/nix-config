{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.whisper-cpp;
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
      description = "ggml model file for whisper-cli";
    };
    source = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "PipeWire node.name of the source to record from; null uses the default source";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ dictateScript ];
  };
}
