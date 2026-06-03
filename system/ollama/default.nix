{ config, lib, pkgs, ... }:

let
  cfg = config.modules.ollama;
in
{
  options.modules.ollama = {
    enable = lib.mkEnableOption "ollama local LLM server";

    modelsPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/ollama/models";
      description = "Path where Ollama stores its downloaded models.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      host = "0.0.0.0";
      package = pkgs.ollama-rocm;
      models = cfg.modelsPath;
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      };
    };

    networking.firewall.interfaces."podman+".allowedTCPPorts = [ 11434 ];
  };
}
