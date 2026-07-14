#!/bin/sh
# dpms-ensure.sh on|off [--settle] — set panel power to a definite state.
#
# The dpms dispatcher's only non-toggle form is hl.dsp.dpms({ action = "on" })
# (upstream: hlDpms → Internal::tableToggleAction reads the "action" field).
# Any other argument — hl.dsp.dpms("on"), booleans, { mode = "on" } — is
# SILENTLY treated as toggle, which is how the raw calls in hypridle.conf
# used to flip an already-on panel OFF at the first keypress after resume
# (dark screen, input still registering). Route all dpms calls through here.
#
# --settle (for after_sleep_cmd): re-assert over ~10s and log state. Dock
# connectors that changed during sleep make aquamarine's post-resume rescan
# disable eDP-1 ("drm: Cannot commit when a page-flip is awaiting") *after*
# a one-shot assert would have run.
#
# Absolute paths / plain POSIX tools only: hypridle's PATH has no mise shims.

TARGET="$1" # on|off
LOG="${XDG_STATE_HOME:-$HOME/.local/state}/hypr-dpms-ensure.log"

case "$TARGET" in on | off) ;; *) echo "usage: $0 on|off [--settle]" >&2; exit 2 ;; esac

assert() { hyprctl dispatch "hl.dsp.dpms({ action = \"$TARGET\" })" >/dev/null 2>&1; }
state() { hyprctl monitors -j 2>/dev/null | grep -m1 -o '"dpmsStatus": *[a-z]*'; }

if [ "$2" = "--settle" ]; then
    # Keep the diagnostic log from growing unbounded.
    if [ -f "$LOG" ] && [ "$(wc -c <"$LOG")" -gt 100000 ]; then
        tail -c 50000 "$LOG" >"$LOG.tmp" && mv "$LOG.tmp" "$LOG"
    fi
    {
        echo "--- settle $TARGET $(date '+%F %T')"
        for delay in 0 1 2 3 4; do # asserts at t ~= 0, 1, 3, 6, 10s
            sleep "$delay"
            echo "t+${delay}: $(state)"
            assert
        done
        echo "final: $(state)"
    } >>"$LOG" 2>&1
else
    assert
fi
