#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."

# Get a list of available Wi-Fi networks and format it
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | uniq | awk '{security = ($1 ~ /WPA/) ? "" : ($1 ~ /WEP/) ? "" : ""; printf "%s %s\n", security, $2}' | column -t)

# Check if Wi-Fi is enabled or disabled
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪  Disable Wi-Fi"
else
    toggle="󰖩  Enable Wi-Fi"
fi

# Use rofi to select a Wi-Fi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: ")

# Get the name of the chosen connection (if any)
read -r chosen_id <<< "${chosen_network:3}"

# Handle different cases based on user input
if [ -z "$chosen_network" ]; then
    exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
    nmcli radio wifi on
    exit
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
    nmcli radio wifi off
    exit
else
    # Message to display when the connection is successfully established
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
    
    # Check for saved connections
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
    else
        if [[ "$chosen_network" =~ "" ]]; then
            wifi_password=$(rofi -dmenu -p "Password: ")
        fi
        nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi
