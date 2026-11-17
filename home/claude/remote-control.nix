{ lib, ... }:
with lib;
{
  options.remoteControl = mkOption {
    type = types.attrsOf types.str;
    default = { };
  };
}
