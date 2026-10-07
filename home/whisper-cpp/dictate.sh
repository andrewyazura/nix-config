dir=$XDG_RUNTIME_DIR/dictate; pidf=$dir/rec.pid; wav=$dir/in.wav; logf=$dir/whisper.log
mkdir -p "$dir"
if [ -f "$pidf" ]; then
  pid=$(cat "$pidf"); rm "$pidf"
  kill -TERM "$pid"; tail --pid="$pid" -f /dev/null
  if [ "${1:-}" = cancel ]; then
    notify-send whisper "Cancelled"
    exit
  fi
  notify-send whisper "Processing"
  whisper-cli -m "$WHISPER_CPP_MODEL" -f "$wav" -nt -np -l en 2>"$logf" | tr '\n' ' ' | sed 's/^ *//; s/ *$//' | wl-copy
  notify-send whisper "Copied"
elif [ "${1:-}" != cancel ]; then
  pw-record ${DICTATE_SOURCE:+--target "$DICTATE_SOURCE"} --rate 16000 --channels 1 --format s16 "$wav" & echo $! > "$pidf"
  notify-send whisper "Listening"
fi
