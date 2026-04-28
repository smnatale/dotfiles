#!/bin/sh

# Get network details
SSID=$(networksetup -getairportnetwork en1 2>/dev/null | grep -v "not associated" | grep -v "not a Wi-Fi" | cut -d: -f2 | xargs)
if [ -z "$SSID" ] || [ "$SSID" = "You are not associated with an AirPort network." ]; then
  SSID="Not connected"
fi

IP=$(ifconfig en1 2>/dev/null | grep "inet " | awk '{print $2}')
if [ -z "$IP" ]; then
  IP="N/A"
fi

SIGNAL=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I 2>/dev/null | grep "agrCtlRSSI" | awk '{print $2}')
if [ -n "$SIGNAL" ]; then
  SIGNAL="${SIGNAL} dBm"
else
  SIGNAL="N/A"
fi

sketchybar --set wifi.detail label="SSID: ${SSID}"
sketchybar --set wifi.detail2 label="IP: ${IP}"
sketchybar --set wifi.detail3 label="Signal: ${SIGNAL}"