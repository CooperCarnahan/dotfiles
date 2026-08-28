-- Personal input overrides.
--
-- Loaded by Omarchy's hyprland.lua after default/hypr/input.lua, so the keys
-- set here replace Omarchy's values and everything else is left alone.

hl.config({
	input = {
		touchpad = {
			-- Omarchy ships natural_scroll = false (default/hypr/input.lua).
			-- The pre-Omarchy config had it true, and that is the preference.
			-- Confirm after apply with:
			--   hyprctl getoption input:touchpad:natural_scroll   -> 1
			natural_scroll = true,
		},
	},
})

-- kb_options is deliberately not set here: Omarchy computes it (compose:caps,
-- a shift:both_capslock_cancel fallback, and grp:alts_toggle for non-Latin
-- vconsole layouts). Hard-setting it drops the compose key and breaks the
-- guard that keeps SUPER bindings reachable on a non-Latin layout.
