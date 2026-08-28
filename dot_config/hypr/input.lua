-- Personal input overrides.
--
-- Loaded by Omarchy's hyprland.lua after default/hypr/input.lua, so the keys
-- set here replace Omarchy's values and everything else is left alone.
--
-- Call shape verified against /usr/share/omarchy/default/hypr/input.lua and the
-- shipped stub at /usr/share/omarchy/config/hypr/input.lua: it is
-- `hl.config({ input = { touchpad = { ... } } })`, NOT `hl.input({ ... })`.

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

-- Deliberately NOT carried over from the pre-Omarchy config/input.lua:
--
--   kb_options = "ctrl:nocaps"
--     Omarchy computes kb_options itself (compose:caps plus a
--     shift:both_capslock_cancel fallback, and grp:alts_toggle when the
--     vconsole layout is non-Latin). Hard-setting it would drop the compose
--     key and break the non-Latin-layout guard that keeps SUPER bindings
--     reachable. Re-add via this file only after reading Omarchy's logic.
--
--   follow_mouse / float_switch_override_focus / gestures / binds
--     Behavioural preferences with no reported problem under Omarchy's
--     defaults. Left out rather than ported blind; add back individually if a
--     specific default actually annoys.
--
--   the three hl.gesture() calls (3-finger workspace / close / fullscreen)
--     Omarchy's stub documents the same API, so these can be restored
--     verbatim if wanted -- but Omarchy's own gesture defaults were never
--     evaluated on this machine, so they get a chance first.
--
-- NOTE, unresolved overlap: Omarchy sets o.window("com.mitchellh.ghostty",
-- { scroll_touchpad = 0.2 }) in its input.lua, which stacks with the personal
-- `mouse-scroll-multiplier = discrete:.6` in the ghostty config. Pick one when
-- ghostty is reconciled (plan C6/C7); this file deliberately does not add a
-- third scroll knob.
