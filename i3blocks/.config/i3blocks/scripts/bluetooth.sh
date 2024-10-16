#!/bin/bash

connected_devices=$(timeout 0.5 bluetoothctl devices | grep "Device" | wc -l)

if [ "$connected_devices" -gt 0 ]; then
    echo "󰂯 $connected_devices"
    echo "󰂯"
    echo "#7aa2f7"
else
    echo "󰂲"  
    echo "󰂲"
    echo "#545c7e"
fi
