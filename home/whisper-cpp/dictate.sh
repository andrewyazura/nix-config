dir=$XDG_RUNTIME_DIR/dictate; pidf=$dir/rec.pid; wav=$dir/in.wav; logf=$dir/whisper.log; idf=$dir/notify.id
mkdir -p "$dir"
notify() {
  local id
  id=$(notify-send -a Dictate -p -r "$(cat "$idf" 2>/dev/null || echo 0)" "$@")
  echo "$id" > "$idf"
}
if [ -f "$pidf" ]; then
  pid=$(cat "$pidf"); rm "$pidf"
  kill -TERM "$pid"; tail --pid="$pid" -f /dev/null
  if [ "${1:-}" = cancel ]; then
    notify Cancelled "Nothing copied"
    exit
  fi
  notify -t 0 Transcribing "The text goes to the clipboard"
  text=$(whisper-cli -m "$WHISPER_CPP_MODEL" -f "$wav" -nt -np -l en 2>"$logf" | tr '\n' ' ' | sed 's/^ *//; s/ *$//')
  if ! grep -q '[[:alnum:]]' <<<"${text//"[BLANK_AUDIO]"/}"; then
    notify "Nothing heard" "Clipboard unchanged"
  else
    printf '%s' "$text" | wl-copy
    notify Copied "$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' <<<"$text")"
  fi
elif [ "${1:-}" != cancel ]; then
  pw-record ${DICTATE_SOURCE:+--target "$DICTATE_SOURCE"} --rate 16000 --channels 1 --format s16 "$wav" & echo $! > "$pidf"
  notify -t 0 Listening "Super+D stops, Super+Shift+D cancels"
fi
