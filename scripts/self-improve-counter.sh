#!/usr/bin/env bash
# UserPromptSubmit hook: count user turns per session and nudge a self-improve
# retro every N turns. Anything printed to stdout is added to Claude's context.
set -u
N="${SELF_IMPROVE_EVERY:-20}"
input="$(cat)"

# session_id from the hook's JSON payload (python if present, sed fallback)
if command -v python3 >/dev/null 2>&1; then
  sid="$(printf '%s' "$input" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("session_id",""))' 2>/dev/null)"
else
  sid="$(printf '%s' "$input" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
fi
[ -z "${sid:-}" ] && sid="default"

dir="${HOME}/.claude/state/self-improve"
mkdir -p "$dir"
f="$dir/${sid}.count"
c="$(cat "$f" 2>/dev/null || echo 0)"
c=$((c + 1))
printf '%s\n' "$c" > "$f"

if [ "$N" -gt 0 ] && [ $((c % N)) -eq 0 ]; then
  echo "[self-improve] Turn ${c}: a retro is due. Run the self-improve skill (in the background if possible, or at the next natural pause). Skip if a retro is already running."
fi
exit 0
