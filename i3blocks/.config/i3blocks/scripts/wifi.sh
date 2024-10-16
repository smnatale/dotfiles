#!/bin/bash

wifi_signal=$(iwconfig 2>/dev/null | grep -i 'signal level' | awk -F '=' '{print $3}' | awk '{print $1}')
wifi_connected=$(iwgetid -r)

if [ -n "$wifi_connected" ]; then
    if [ "$wifi_signal" -gt -50 ]; then
        echo "󰤨"  
        echo "󰤨"  
	echo "#9ece6a"
    elif [ "$wifi_signal" -gt -70 ]; then
        echo "󰤥" 
        echo "󰤥" 
	echo "#9ece6a"
    elif [ "$wifi_signal" -gt -80 ]; then
        echo "󰤢"
        echo "󰤢"
	echo "#9ece6a"
    else
        echo "󰤟"
        echo "󰤟"
	echo "#9ece6a"
    fi
else
	echo "󰖩"
	echo "󰖩"
	echo "#545c7e"
fi

