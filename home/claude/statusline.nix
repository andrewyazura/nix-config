{ lib, pkgs }:
let
  settings = {
    version = 3;
    lines = [
      # Line 1: model, context, session timer, cost
      [
        {
          id = "1";
          type = "model";
          color = "cyan";
        }
        {
          id = "2";
          type = "separator";
        }
        {
          id = "3";
          type = "context-bar";
          color = "brightBlack";
        }
        {
          id = "4";
          type = "separator";
        }
        {
          id = "5";
          type = "context-percentage";
          color = "brightBlack";
        }
        {
          id = "6";
          type = "separator";
        }
        {
          id = "7";
          type = "session-clock";
          color = "blue";
        }
        {
          id = "8";
          type = "separator";
        }
        {
          id = "9";
          type = "session-cost";
          color = "green";
        }
      ]

      # Line 2: token breakdown, git info
      [
        {
          id = "10";
          type = "tokens-input";
          color = "brightBlack";
        }
        {
          id = "11";
          type = "separator";
        }
        {
          id = "12";
          type = "tokens-output";
          color = "brightBlack";
        }
        {
          id = "13";
          type = "separator";
        }
        {
          id = "14";
          type = "tokens-cached";
          color = "brightBlack";
        }
        {
          id = "15";
          type = "separator";
        }
        {
          id = "16";
          type = "git-branch";
          color = "magenta";
        }
        {
          id = "17";
          type = "separator";
        }
        {
          id = "18";
          type = "git-changes";
          color = "yellow";
        }
      ]

      # Line 3: unused
      [ ]
    ];
    flexMode = "full-minus-40";
    compactThreshold = 60;
    colorLevel = 2;
    inheritSeparatorColors = false;
    globalBold = false;
    powerline = {
      enabled = false;
      separators = [ "" ];
      separatorInvertBackground = [ false ];
      startCaps = [ ];
      endCaps = [ ];
      autoAlign = false;
    };
  };

  settingsFile = pkgs.writeText "ccstatusline-settings.json" (builtins.toJSON settings);
in
{
  configFile = {
    "ccstatusline/settings.json" = {
      source = settingsFile;
      force = true;
    };
  };

  command = "ccstatusline";
}
