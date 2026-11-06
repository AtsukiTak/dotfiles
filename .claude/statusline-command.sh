#!/bin/bash
# Pure-style status line for Claude Code.
# Layout (2 lines):
#   line 1: <model> <effort> | ctx <bar> <used>% | 7d <bar> <used>% in <time to reset>
#   line 2: <dir in blue> <branch in dim grey><dirty marker>
# ctx is context used, 7d is the weekly rate limit used. Both are shown as a
# 10-cell bar (one █ per 10%, ░ for the rest) plus the percentage, coloured
# yellow from 70% and red from 90%. 7d ends with the time until the window resets.

input=$(cat)

# Pull every field in a single jq call, separated by the unit separator (0x1f)
IFS=$'\x1f' read -r cwd model effort ctx week reset < <(printf '%s' "$input" | jq -r '
  def used: if . == null then "" else (round | tostring) end;
  [
    (.workspace.current_dir // .cwd // ""),
    (.model.display_name // ""),
    (.effort.level // ""),
    (.context_window.used_percentage // null | used),
    (.rate_limits.seven_day.used_percentage // null | used),
    (.rate_limits.seven_day.resets_at // "" | tostring)
  ] | join("\u001f")')
[ -z "$cwd" ] && cwd=$(pwd)

# Abbreviate the home directory to ~
dir="$cwd"
case "$dir" in
  "$HOME") dir="~" ;;
  "$HOME"/*) dir="~${dir#"$HOME"}" ;;
esac

# Git info: local only (no fetch), skip optional locks
branch=""
dirty=""
if git --no-optional-locks -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git --no-optional-locks -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null \
    || git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$(git --no-optional-locks -C "$cwd" status --porcelain 2>/dev/null | head -n 1)" ]; then
    dirty="*"
  fi
fi

BLUE=$'\033[34m'
GREY=$'\033[38;5;242m'
PINK=$'\033[38;5;218m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

# Colour for a "used" percentage: grey, yellow from 70%, red from 90%
used_color() {
  if [ "$1" -ge 90 ]; then printf '%s' "$RED"
  elif [ "$1" -ge 70 ]; then printf '%s' "$YELLOW"
  else printf '%s' "$GREY"
  fi
}

# 10-cell bar for a percentage: one █ per 10% (rounded down), ░ for the rest
bar_for() {
  local filled=$(( $1 / 10 )) bar="" i
  [ "$filled" -gt 10 ] && filled=10
  for (( i = 0; i < 10; i++ )); do
    if [ "$i" -lt "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
  done
  printf '%s' "$bar"
}

# "<label> <bar> <used>%" with the bar and number coloured by usage
gauge() {
  printf '%s' "${GREY}$1${RESET} $(used_color "$2")$(bar_for "$2") $2%${RESET}"
}

# Line 1: segments separated by " | "
out=""
add() { if [ -z "$out" ]; then out="$1"; else out="${out} ${GREY}|${RESET} $1"; fi; }

# "<model> <effort>"
head=""
[ -n "$model" ]  && head="$model"
[ -n "$effort" ] && head="${head:+$head }$effort"
[ -n "$head" ]   && add "${GREY}${head}${RESET}"

# "ctx <bar> <used>%"
[ -n "$ctx" ] && add "$(gauge ctx "$ctx")"

# "7d <bar> <used>% in <time to reset>"
if [ -n "$week" ]; then
  remain=""
  if [ -n "$reset" ]; then
    secs=$(( reset - $(date +%s) ))
    [ "$secs" -lt 0 ] && secs=0
    if [ "$secs" -ge 86400 ]; then remain="$(( secs / 86400 ))d"
    elif [ "$secs" -ge 3600 ]; then remain="$(( secs / 3600 ))h"
    else remain="$(( secs / 60 ))m"
    fi
  fi
  rl="$(gauge 7d "$week")"
  [ -n "$remain" ] && rl="${rl} ${GREY}in ${remain}${RESET}"
  add "$rl"
fi

line2="${BLUE}${dir}${RESET}"
if [ -n "$branch" ]; then
  line2="${line2} ${GREY}${branch}${RESET}"
  [ -n "$dirty" ] && line2="${line2}${PINK}${dirty}${RESET}"
fi

printf '%s\n%s\n' "$out" "$line2"
