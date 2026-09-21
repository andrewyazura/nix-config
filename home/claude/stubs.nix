{ lib, name, ... }:
with lib;
{
  options = {
    command = mkOption {
      type = types.str;
      default = "claude-${name}";
    };

    meta.maintainers = mkOption {
      type = types.listOf types.raw;
      default = [ ];
    };

    warnings = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    assertions = mkOption {
      type = types.listOf types.raw;
      default = [ ];
    };

    home = {
      homeDirectory = mkOption { type = types.str; };

      packages = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };

      sessionVariables = mkOption {
        type = types.attrs;
        default = { };
      };

      file = mkOption {
        type = types.attrsOf types.raw;
        default = { };
      };
    };

    programs.mcp = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      servers = mkOption {
        type = types.attrsOf types.raw;
        default = { };
      };
    };
  };
}
