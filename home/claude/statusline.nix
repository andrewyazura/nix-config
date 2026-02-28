{ pkgs }:
pkgs.writeShellScript "claude-statusline" ''
  input=$(cat)

  MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // "?"')
  PCT=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
  DURATION_MS=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.cost.total_duration_ms // 0')

  BAR_WIDTH=10
  FILLED=$((PCT * BAR_WIDTH / 100))
  EMPTY=$((BAR_WIDTH - FILLED))
  BAR=""
  [ "$FILLED" -gt 0 ] && BAR=$(printf "%''${FILLED}s" | tr ' ' '=')
  [ "$EMPTY" -gt 0 ] && BAR="''${BAR}$(printf "%''${EMPTY}s" | tr ' ' '-')"
  DURATION_SEC=$((DURATION_MS / 1000))
  MINS=$((DURATION_SEC / 60))
  SECS=$((DURATION_SEC % 60))

  echo "[$MODEL] [$BAR] [''${PCT}%] [''${MINS}m ''${SECS}s]"
''
