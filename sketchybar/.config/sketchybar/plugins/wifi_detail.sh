#!/bin/sh

# Get network details using system_profiler (more reliable than networksetup/airport)
WIFI_INFO=$(system_profiler SPAirPortDataType 2>/dev/null)

# Get SSID (get first occurrence only)
SSID=$(echo "$WIFI_INFO" | awk '/Current Network Information:/ {getline; print $0; exit}' | sed 's/://g' | xargs)
if [ -z "$SSID" ]; then
  SSID="Not connected"
fi

# Get IP
IP=$(ifconfig en1 2>/dev/null | grep "inet " | awk '{print $2}')
if [ -z "$IP" ]; then
  IP="N/A"
fi

# Get Signal strength from system_profiler
SIGNAL=$(echo "$WIFI_INFO" | grep "Signal / Noise" | head -1 | awk '{print $3 " " $4}')
if [ -z "$SIGNAL" ]; then
  SIGNAL="N/A"
fi

sketchybar --set wifi.detail label="SSID: ${SSID}"
sketchybar --set wifi.detail2 label="IP: ${IP}"
sketchybar --set wifi.detail3 label="Signal: ${SIGNAL}"