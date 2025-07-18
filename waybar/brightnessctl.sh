#!/bin/bash

value=$(brightnessctl get)
command="$1"

threshold=9600

if [[ "$command" == "down" ]]; then
    if (( value > threshold )); then
        brightnessctl set 5%-
    fi

elif [[ "$command" == "up" ]]; then
    brightnessctl set +5%

else
    notify-send "Unknown command: $command"
    exit 1
fi
