#!/bin/bash

# Clock plugin - shows "7 Aug  14:30"

sketchybar --set "$NAME" label="$(date '+%d %b %H:%M')"
