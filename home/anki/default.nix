{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.anki;
  addon = inputs.anki-mcp.packages.${pkgs.stdenv.hostPlatform.system}.addon;
  ankiPackage = (pkgs.anki.withAddons [ addon ]).overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      wrapProgram $out/bin/anki \
        --set QTWEBENGINEPROCESS_PATH "${pkgs.qt6.qtwebengine}/libexec/QtWebEngineProcess" \
        --set QTWEBENGINE_RESOURCES_PATH "${pkgs.qt6.qtwebengine}/resources" \
        --set QTWEBENGINE_LOCALES_PATH "${pkgs.qt6.qtwebengine}/qtwebengine_locales"
    '';
  });
in
{
  options.modules.anki = {
    enable = mkEnableOption "Enable Anki with the MCP server add-on";
  };

  config = mkIf cfg.enable {
    home.packages = [ ankiPackage ];
  };
}
