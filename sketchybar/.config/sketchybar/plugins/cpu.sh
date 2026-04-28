#!/bin/sh

case "$SENDER" in
  "mouse.entered")
    sketchybar --set cpu popup.drawing=on
    ;;
  "mouse.exited")
    sketchybar --set cpu popup.drawing=off
    ;;
  *)
    TOPPROC=$(ps -Arco pid,%cpu,comm | head -2 | tail -1)
    CPU_PCT=$(echo "$TOPPROC" | awk '{print $2}' | cut -d. -f1)
    PROC_NAME=$(echo "$TOPPROC" | awk '{print $3}' | cut -c1-14)

    TOTAL=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s/4}')
    [ -z "$TOTAL" ] && TOTAL=0

    GRAPH_VAL=$(echo "$TOTAL" | awk '{v=$1/100; if(v>1) v=1; printf "%.2f", v}')

    sketchybar --push cpu "$GRAPH_VAL" \
               --set cpu.top label="${CPU_PCT} ${PROC_NAME}"
    ;;
esac
