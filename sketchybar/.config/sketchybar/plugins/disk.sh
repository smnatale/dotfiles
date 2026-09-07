DISK_USAGE=$(df -P / 2>/dev/null | awk 'NR > 1 { sub(/%/, "", $5); print $5; exit }')

sketchybar --set "$NAME" label="${DISK_USAGE:---}%"
