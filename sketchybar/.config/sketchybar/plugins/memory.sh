#!/bin/bash

MEMORY_USAGE=$(vm_stat 2>/dev/null | awk -v total_bytes="$(sysctl -n hw.memsize 2>/dev/null)" '
  /page size of/ {
    gsub(/[^0-9]/, "", $0)
    page_size = $0
  }
  /Pages active:/ { active = $3 }
  /Pages wired down:/ { wired = $4 }
  /Pages occupied by compressor:/ { compressed = $5 }
  END {
    if (page_size == "" || total_bytes == "" || active == "" || wired == "" || compressed == "") {
      exit 1
    }

    used_bytes = (active + wired + compressed) * page_size
    printf "%.0f", used_bytes / total_bytes * 100
  }
')

sketchybar --set "$NAME" label="${MEMORY_USAGE:---}%"
