#!/bin/bash

action="$1"
focused_class=$(hyprctl activewindow | grep 'class:' | awk '{print $2}')

is_terminal=false
case "$focused_class" in
    Alacritty|kitty|foot|wezterm|gnome-terminal|konsole|xterm)
        is_terminal=true
        ;;
esac


# Determine key based on context and action
if [[ "$action" == "copy" ]]; then
    if $is_terminal; then
        echo "key ctrl+shift+c" | dotoolc
    else
        echo "key ctrl+c" | dotoolc
    fi
elif [[ "$action" == "paste" ]]; then
    if $is_terminal; then
        echo "key ctrl+shift+v" | dotoolc
    else
        echo "key ctrl+v" | dotoolc
    fi
else
    notify-send "Unknown action: $action"
    exit 1
fi