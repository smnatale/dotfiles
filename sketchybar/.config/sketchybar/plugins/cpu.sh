#!/bin/bash

CPU_USAGE=$(LC_ALL=C top -l 2 -n 0 -s 1 2>/dev/null | awk '
  /CPU usage:/ {
    user = $3
    sys = $5
    gsub("%", "", user)
    gsub("%", "", sys)
    usage = user + sys
  }
  END {
    if (usage != "") {
      printf "%.0f", usage
    }
  }
')

sketchybar --set "$NAME" label="${CPU_USAGE:---}%"
