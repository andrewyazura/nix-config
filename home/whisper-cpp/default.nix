{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.whisper-cpp;
  recordScript = pkgs.writeShellApplication {
    name = "whisper-record";
    text = (builtins.readFile ./record.sh);
    runtimeInputs = with pkgs; [
      cfg.package
      libnotify
      sox
      wl-clipboard
    ];
    runtimeEnv = {
      WHISPER_CPP_MODEL = "${cfg.model}";
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
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ recordScript ];
  };
}
