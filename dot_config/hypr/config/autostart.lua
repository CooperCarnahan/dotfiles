local programs = require("config.programs")

-- ──────────────────────────────────────────────────────────────────────────
-- Environment variables (formerly environment.conf)
-- ──────────────────────────────────────────────────────────────────────────
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE",    "24")
hl.env("QT_CURSOR_SIZE",  "24")

-- ──────────────────────────────────────────────────────────────────────────
-- Startup commands
-- ──────────────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
    -- vicinae launcher daemon
    hl.exec_cmd("vicinae server")

    -- wallpaper
    hl.exec_cmd([[swaybg -o '*' -i /usr/share/wallpapers/cachyos-wallpapers/Skyscraper.png -m fill]])

    -- bar, input method, notifications, network, polkit
    hl.exec_cmd("waybar &")
    hl.exec_cmd("fcitx5 -d &")
    hl.exec_cmd("swaync &")
    hl.exec_cmd("nm-applet --indicator &")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")

    -- volume overlay (wob) FIFO
    hl.exec_cmd([[bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &]])

    -- workspace-pinned launches
    hl.exec_cmd("[workspace 1] "                                       .. programs.terminal)
    hl.exec_cmd("[workspace 2 silent] "                                .. programs.browser)
    hl.exec_cmd("[workspace special:quake silent] ghostty --title=quake-terminal")
    hl.exec_cmd("[workspace special:1password silent; no_initial_focus] 1password --silent")

    -- dynamic monitor configuration daemon
    hl.exec_cmd("hyprdynamicmonitors run")

    -- environment propagation for dbus / systemd user services
    hl.exec_cmd("systemctl --user import-environment &")
    hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null &")
    hl.exec_cmd("dbus-update-activation-environment --systemd &")

    -- idle handler
    hl.exec_cmd(programs.idlehandler)
end)
