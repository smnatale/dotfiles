#!/bin/bash
# Claude Code status line - Rose Pine theme
# Shows: model name, rate limit usage (5h/7d), context window remaining

input=$(cat)

# Rose Pine palette (truecolor ANSI)
c_reset=$'\033[0m'
c_muted=$'\033[38;2;110;106;134m'   # muted
c_subtle=$'\033[38;2;144;140;170m'  # subtle
c_love=$'\033[38;2;235;111;146m'    # love
c_gold=$'\033[38;2;246;193;119m'    # gold
c_foam=$'\033[38;2;156;207;216m'    # foam
c_iris=$'\033[38;2;196;167;231m'    # iris

# Pick a color based on a "danger" percentage (higher = worse)
danger_color() {
	local pct_int="${1%.*}"
	if [ "$pct_int" -ge 80 ]; then
		echo "$c_love"
	elif [ "$pct_int" -ge 50 ]; then
		echo "$c_gold"
	else
		echo "$c_foam"
	fi
}

# Pick a color based on a "remaining" percentage (lower = worse)
remaining_color() {
	local pct_int="${1%.*}"
	if [ "$pct_int" -ge 50 ]; then
		echo "$c_foam"
	elif [ "$pct_int" -ge 20 ]; then
		echo "$c_gold"
	else
		echo "$c_love"
	fi
}

model=$(echo "$input" | jq -r '.model.display_name // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

segments=()

# Model name
if [ -n "$model" ]; then
	segments+=("${c_iris}${model}${c_reset}")
fi

# Rate limit usage (5h / 7d)
rate_str=""
if [ -n "$five" ]; then
	color=$(danger_color "$five")
	rate_str="${c_subtle}5h:${c_reset}${color}$(printf '%.0f' "$five")%${c_reset}"
fi
if [ -n "$week" ]; then
	color=$(danger_color "$week")
	[ -n "$rate_str" ] && rate_str="${rate_str} "
	rate_str="${rate_str}${c_subtle}7d:${c_reset}${color}$(printf '%.0f' "$week")%${c_reset}"
fi
[ -n "$rate_str" ] && segments+=("$rate_str")

# Context window remaining
if [ -n "$remaining" ]; then
	color=$(remaining_color "$remaining")
	segments+=("${c_subtle}ctx:${c_reset}${color}$(printf '%.0f' "$remaining")%${c_reset}")
fi

# Join segments with a muted separator
output=""
for segment in "${segments[@]}"; do
	if [ -z "$output" ]; then
		output="$segment"
	else
		output="${output} ${c_muted}|${c_reset} ${segment}"
	fi
done

printf '%s' "$output"
