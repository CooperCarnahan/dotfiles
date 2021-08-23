#!/usr/bin/env bash

dir="$HOME/.config/polybar/siduck76"
# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

DIR="$HOME/.config/polybar/siduck76"

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar black >>/tmp/polybar1.log 2>&1 & disown
# if type "xrandr"; then
#     for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#         MONITOR=$m polybar --reload $m -c "$dir/$style/config.ini" &
#     done
# else
#     polybar -q main -c "$dir/$style/config.ini" &
# fi
polybar main -c "$DIR"/config.ini >>/tmp/polybar1.log 2>&1 & disown
# polybar left -c "$DIR"/config.ini >>/tmp/polybar2.log 2>&1 & disown
# polybar right -c "$DIR"/config.ini >>/tmp/polybar3.log 2>&1 & disown
echo "Bars launched..."
