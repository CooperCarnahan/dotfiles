local colors = require("config.colors")

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 5,
		border_size = 3,
		layout = "dwindle",
		col = {
			active_border = colors.cachylgreen,
			inactive_border = colors.cachymblue,
		},
		snap = {
			enabled = true,
		},
	},

	group = {
		col = {
			border_active = colors.cachydgreen,
			border_inactive = colors.cachylgreen,
			border_locked_active = colors.cachymgreen,
			border_locked_inactive = colors.cachydblue,
		},
		groupbar = {
			font_family = "Fira Sans",
			text_color = colors.cachydblue,
			col = {
				active = colors.cachydgreen,
				inactive = colors.cachylgreen,
				locked_active = colors.cachymgreen,
				locked_inactive = colors.cachydblue,
			},
		},
	},

	misc = {
		font_family = "Fira Sans",
		splash_font_family = "Fira Sans",
		disable_hyprland_logo = false,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		col = { splash = colors.cachylgreen },
		background_color = colors.cachydblue,
		enable_swallow = true,
		swallow_regex = "^(firefox|nautilus|nemo|thunar|btrfs-assistant.)$",
		focus_on_activate = true,
		vrr = 2,
	},

	render = {
		direct_scanout = true,
	},

	-- Hand XWayland clients the native pixel grid instead of upscaling their
	-- output by the monitor scale (1.5 here). Without this, anything on XWayland
	-- renders at logical size and gets stretched — the classic HiDPI blur.
	-- Clients must then do their own scaling: winboat's FreeRDP windows are
	-- covered by scaleDesktop in ~/.winboat/winboat.config.json. Any future X11
	-- app that can't scale itself will appear small and needs GDK_SCALE/
	-- QT_SCALE_FACTOR in config/autostart.lua.
	xwayland = {
		force_zero_scaling = true,
	},

	dwindle = {
		special_scale_factor = 0.8,
		preserve_split = true,
	},

	master = {
		new_status = "master",
		special_scale_factor = 0.8,
	},

	decoration = {
		rounding = 4,
		blur = {
			size = 15,
			passes = 2,
			xray = true,
		},
		shadow = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Animation curves & per-leaf settings. Animations are disabled globally above,
-- but the curve and per-leaf definitions are preserved so flipping the master
-- switch on later "just works".
hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "workspacesIn", enabled = false, speed = 6, bezier = "default", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = false, speed = 6, bezier = "default", style = "slidefade 80%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6, bezier = "default", style = "fade" })
