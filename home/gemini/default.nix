{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.gemini;

  # Define the settings structure matching the CLI's expectation
  geminiSettings = {
    tools = {
      autoAccept = true;
    };
    general = {
      preferredEditor = "nvim";
      vimMode = true;
      previewFeatures = true;
    };
    security = {
      auth = {
        selectedType = "gemini-api-key";
      };
    };
    ui = {
      theme = "Default";
    };
  };

  # Generate the JSON file in the Nix store
  geminiSettingsFile = pkgs.writeText "gemini-settings.json" (builtins.toJSON geminiSettings);
in
{
  options.modules.gemini = {
    enable = mkEnableOption "Enable gemini configuration";
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;
      # We manage the settings file manually to avoid symlink conflicts
      settings = { };
    };

    # Disable the module's automatic file generation (assuming it uses this path)
    home.file.".gemini/settings.json".enable = false;

    # Activation script to copy the config file
    home.activation.configureGemini = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $HOME/.gemini
      $DRY_RUN_CMD cp -f ${geminiSettingsFile} $HOME/.gemini/settings.json
      $DRY_RUN_CMD chmod 644 $HOME/.gemini/settings.json
    '';
  };
}
