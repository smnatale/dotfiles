#!/usr/bin/env bash

notify-send "Getting list of available Bluetooth devices..."

# Function to list available Bluetooth devices
list_devices() {
    bluetoothctl devices | sed 's/Device //;s/^[[:space:]]*//'
}

# Function to get the current Bluetooth status
get_bluetooth_status() {
    bluetoothctl show | grep "Powered" | awk '{print $2}'
}

# Function to toggle Bluetooth
toggle_bluetooth() {
    local status=$(get_bluetooth_status)
    if [[ "$status" == "yes" ]]; then
        bluetoothctl power off
        notify-send "Bluetooth Disabled"
    else
        bluetoothctl power on
        notify-send "Bluetooth Enabled"
    fi
}

# List available Bluetooth devices
device_list=$(list_devices)

# Check Bluetooth status and set toggle option
if [[ $(get_bluetooth_status) == "yes" ]]; then
    toggle="󰖪  Disable Bluetooth"
else
    toggle="󰖩  Enable Bluetooth"
fi

# Use rofi to select a Bluetooth device or toggle Bluetooth
chosen_device=$(echo -e "$toggle\n$device_list" | rofi -dmenu -i -p "Select Device: ")

# Handle user choice
if [ -z "$chosen_device" ]; then
    exit
elif [[ "$chosen_device" == "󰖩  Enable Bluetooth" || "$chosen_device" == "󰖪  Disable Bluetooth" ]]; then
    toggle_bluetooth
else
    # Extract device address and name
    device_address=$(echo "$chosen_device" | awk '{print $1}')
    device_name=$(echo "$chosen_device" | cut -d ' ' -f 2-)

    # Connect to the selected device
    if bluetoothctl connect "$device_address"; then
        notify-send "Connected" "You are now connected to $device_name."
    else
        notify-send "Connection Failed" "Could not connect to $device_name."
    fi
fi
