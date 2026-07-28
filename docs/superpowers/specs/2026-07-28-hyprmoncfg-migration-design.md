# Migrating Hyprland monitor management to hyprmoncfg

**Date:** 2026-07-28
**Status:** Approved, not yet implemented

## Problem

Hyprland 0.56.1 uses the Lua config API. `hyprland.lua` loads monitor config via
`require("config.monitors")`, so the generated file must be valid Lua.

hyprdynamicmonitors (HDM) v1.4.0 emits **legacy conf syntax** (`monitor=desc:...,disable`)
from a single function, `internal/profilemaker/service.go:305 ToHyprLines()`. Its `freeze`
and TUI commands therefore write a syntactically invalid file into a Lua `require()` target.
This is upstream issue #151, open, with no release since 2026-02-02.

The workaround was hand-written Lua templates. That worked but produced a three-engine
collision — Hyprland Lua, HDM Go templates, and chezmoi Go templates — requiring `.literal`
suffixes to stop chezmoi from interpreting HDM's `{{ }}`.

Two further defects were confirmed during investigation:

1. **Profile data loss.** `modify_config.toml` is a chezmoi modify-template that reads the
   *existing target file* (`.chezmoi.stdin | fromToml`) and only force-pins
   `general.destination`. On a fresh machine stdin is empty, so the render collapses to
   `[general]` alone and all four profiles are lost. Profiles were never actually backed up.
2. **Untracked template.** `peytonville.go.tmpl` existed only on the local machine; the
   chezmoi source held three templates while the live directory held four.

## Decision

Replace HDM (and the separate authoring tool it would have required) with **hyprmoncfg**
— a single MIT-licensed Go tool providing a TUI layout editor, a profile store, and a
hotplug/lid-aware daemon, with native Hyprland Lua output.

### Why hyprmoncfg

Verified against source and against this machine:

- Emits `hl.monitor({ ... })` **and** `hl.workspace_rule({ ... })`; output validated with `luac -p`
- `hyprmoncfgd` auto-switches on hotplug via socket2 (`SubscribeMonitorEvents`) and is lid-aware
- `VerifyLuaIncludeChain()` refuses to write unless the target is genuinely `require()`d —
  a direct guard against the bug class that motivated this work
- `luaQuote` escaping, atomic writes (temp + rename)
- Zero runtime dependencies; AUR-packaged (`hyprmoncfg 1.8.0-1`) with a stock systemd unit
- `save` is a working Lua equivalent of HDM's broken `freeze`, and captures workspace rules

### Alternatives rejected

| Option | Reason |
|---|---|
| kanshi / shikane | Hyprland bug #1274 — disabled heads vanish from the output list; breaks disable-on-dock |
| way-displays | Explicitly does not support Hyprland |
| hyprmon | No hotplug daemon (README roadmap item unchecked); would still need HDM alongside |
| monique | Capable (Lua + hotplug), but GUI-only and requires a Python + GTK4 + libadwaita stack |
| Upstream Lua PR to HDM | Real feature, not a patch (format selection, escaping, both starter templates, tests), gated on a maintainer idle 6 months |

### Non-blocking known issue

`apply.go` has no Lua-awareness and issues `keyword monitor` / `keyword workspace`, both of
which Hyprland's Lua parser rejects. This is **harmless**: `hyprctl` exits 0 even when
printing `keyword can't work with non-legacy parsers`, and `Client.Batch` only inspects the
process exit code, so it returns `nil` — no error, no spurious revert. The real work happens
via writing `monitors.lua` then `Reload()`, confirmed by `waitForAppliedProfile`.

## Target architecture

```
~/.config/hypr/hyprland.lua        require("monitors")     authored, chezmoi-tracked
~/.config/hypr/monitors.lua        GENERATED, chezmoi-ignored
~/.config/hypr/config/*.lua        7 authored modules, tracked (unchanged)
~/.config/hyprmoncfg/profiles/     4 JSON profiles + sidecars, tracked (source of truth)
hyprmoncfgd.service                stock packaged unit, enabled
```

**Layout rule:** `config/` holds authored, tracked source. The top level holds generated,
ignored state. `~/.config/hypr/monitors.lua` and `require("monitors")` are hyprmoncfg's
documented defaults, so this needs no flags and no systemd drop-in.

Eliminated entirely: HDM, both its systemd units, all four `.go.tmpl` templates, the Go
template layer, the chezmoi `.literal` mechanism, `modify_config.toml`, `[power_events]`,
and the UPower/D-Bus dependency.

## Profile model

Matching is by hardware identity, not connector name. Both sides derive the same key:
runtime `Monitor.HardwareKey()` and profile-side `outputMatchKeyFromFields()` both join
`make|model|serial` from the discrete fields `hyprctl` reports. This is why profiles survive
connector changes — the same dock already presents the home displays as `DP-8`/`DP-10` and
the office displays as `DP-9`/`DP-10`.

Exactly three profiles. No backups, experiments, or duplicates may remain in the profiles
directory: `hyprmoncfgd` scores **every** `*.json` in it, and stale files silently compete
during matching.

| Profile | Hardware | Provenance | Key confidence |
|---|---|---|---|
| `office` | `hp inc.\|hp z27k g3\|cn4322194x` + `...\|cn432218ry`, eDP-1 disabled | `hyprmoncfg save` against live hardware | exact |
| `docked-home` | `aoc\|u2790b\|0x0001947d` + `...\|0x0001895e`, eDP-1 disabled | Hand-authored from Appendix A | exact |
| `undocked` | `samsung display corp.\|0x41b3\|0x0000ff01` only | `save` after undocking | exact |

All values required to author these profiles are recorded in Appendix A. This matters
because step 6 deletes the HDM templates, which are otherwise the only durable record of
that geometry.

Every key in this migration is exact. Nothing is inferred.

### peytonville is deliberately deferred

The Samsung LS32D70xE location is used rarely, and its hardware is not reachable now. Its
key would have to be inferred from HDM's concatenated description
(`Samsung Electric Company LS32D70xE HCNX801439`) — the serial is unambiguous as the last
token, but the make/model split is a guess.

Rather than ship the migration's only inferred value, the profile is not created. On the
next visit, `hyprmoncfg save peytonville` captures it exactly from live hardware, followed
by `chezmoi re-add ~/.config/hyprmoncfg`. Its geometry is preserved in Appendix A as a
cross-check, since the HDM template that held it is deleted in step 6.

Until then that location has no auto-switching. This is an accepted trade, not an oversight.

## chezmoi changes

- **Add** `~/.config/hyprmoncfg/` (upstream's documented approach: `chezmoi add`, then
  `chezmoi re-add` after saving or updating any profile)
- **Ignore** `.config/hypr/monitors.lua`, replacing the existing
  `.config/hypr/config/monitors.lua` entry. Upstream warns that committing the active
  generated file causes conflicts between machines with different monitors.
- **Delete** `dot_config/hyprdynamicmonitors/` in full — `modify_config.toml` and
  `private_{docked-home,office,undocked}.go.tmpl.literal` — plus the HDM entries in the
  Linux-GUI block of `.chezmoiignore`
- **Edit** `dot_config/hypr/hyprland.lua`: `require("config.monitors")` → `require("monitors")`

Profiles become real tracked files rather than a passthrough of local state, which closes
the data-loss defect by construction.

## Cutover sequence

Ordered so nothing is destroyed before its replacement is proven.

1. `hyprmoncfg save office` against live hardware. Verify the generated Lua parses
   (`luac -p`) and contains the expected monitors and workspace rules.
2. Author `docked-home` from Appendix A, and capture `undocked` with `save` while
   genuinely undocked. Confirm exactly three `*.json` files exist.
3. Stop and disable `hyprdynamicmonitors.service` and `hyprdynamicmonitors-prepare.service`.
4. Change `hyprland.lua` to `require("monitors")`, apply `office`, and confirm displays and
   workspace pins survive a reload.
5. Enable `hyprmoncfgd`. Verify auto-switching with a real undock/redock cycle.
6. Remove HDM: `-Rns hyprdynamicmonitors-bin`, delete `~/.config/hyprdynamicmonitors/`,
   delete the chezmoi source directory, update `.chezmoiignore`, and commit.

Steps 1–2 are additive; HDM remains authoritative until step 3.

## Rollback

Before step 3, no rollback is needed — HDM still owns the config and nothing has changed.
After step 6, rollback is a `git revert` in the chezmoi repository plus reinstalling the AUR
package. The `.go.tmpl` templates remain recoverable from git history permanently.

The deferred `peytonville` profile is not a rollback scenario; that location simply has no
auto-switching until it is captured on site.

## Verification

- `luac -p` passes on the generated `monitors.lua`
- `hyprctl monitors` reflects the intended layout, with eDP-1 disabled where specified
- Workspaces 1 and 2 land on the intended displays
- A physical undock/redock triggers the daemon and applies the correct profile
- `chezmoi status` is clean and `chezmoi apply --dry-run` shows no unintended changes
- Exactly three `*.json` files in `~/.config/hyprmoncfg/profiles/`

## Out of scope

- **Flattening `~/.config/hypr/config/`.** Raised during design and deliberately deferred.
  It would touch all seven modules, `hyprland.lua`, every chezmoi path, and `.chezmoiignore`,
  and would re-mix generated with authored files. It is a clean standalone refactor if wanted
  later; it is not bundled with a daemon migration.
- **Forcing the home AOC `0x0001895e` display to 60Hz.** It falls back to 30Hz at 4K with
  rotation, most likely DisplayPort bandwidth. Not present at the office, where both HP
  displays run 60Hz. Profiles will record what demonstrably works rather than a mode that
  could fail hyprmoncfg's apply-verification. Worth investigating separately.
- **Upstreaming Lua support to hyprdynamicmonitors.** Moot once HDM is removed.
- **hyprmon.** Never installed; nothing to remove.

## Appendix A — recorded authoring values

Captured 2026-07-28 from live hardware and from the HDM templates before their removal.
Hardware keys are `make|model|serial` as `hyprctl` reports the discrete fields.

### office — captured live, authoritative

| Output | Key | Settings |
|---|---|---|
| eDP-1 | `Samsung Display Corp.\|0x41B3\|0x0000FF01` | disabled |
| DP-9 | `HP Inc.\|HP Z27k G3\|CN4322194X` | 3840x2160@60, pos 4800x-560, scale 1.5, transform 3 |
| DP-10 | `HP Inc.\|HP Z27k G3\|CN432218RY` | 3840x2160@60, pos 6240x0, scale 1.5, transform 0 |

Produced by `save` directly, so these are reference values only. Note DP-9 is rotated
(transform 3) — earlier assumptions about which office display is rotated were wrong.

### docked-home — from HDM template plus live capture

| Output | Key | Settings |
|---|---|---|
| laptop | `Samsung Display Corp.\|0x41B3\|0x0000FF01` | disabled |
| AOC left | `AOC\|U2790B\|0x0001947D` | 3840x2160@60, pos 2160x450, scale 1.5, transform 0 |
| AOC right | `AOC\|U2790B\|0x0001895E` | 3840x2160**@30**, pos 720x-110, scale 1.5, transform 1 |

Workspace rules: workspace 1 → `0x0001947D`, workspace 2 → `0x0001895E`, both persistent.

**The @30 is deliberate.** The HDM template requested 60Hz, but the display demonstrably
runs at 30Hz — likely DisplayPort bandwidth at 4K with rotation. Authoring 60Hz would make
hyprmoncfg request a mode Hyprland then falls back from, and `waitForAppliedProfile` compares
applied state against the profile, so the apply could fail verification and revert. Record
the mode that actually holds; investigate the bandwidth question separately.

### undocked — from HDM template

| Output | Key | Settings |
|---|---|---|
| eDP-1 | `Samsung Display Corp.\|0x41B3\|0x0000FF01` | 2880x1800@120, pos 1760x1520, scale 1.5, transform 0 |

Position is inherited from a docked capture and is arbitrary for a sole display. Prefer
capturing this profile with `save` while genuinely undocked.

### peytonville — NOT created; recorded for future recreation

Deferred by decision (see "peytonville is deliberately deferred"). These values are preserved
only because step 6 deletes the HDM template that held them. Use them to sanity-check the
profile captured on site, not to author one now.

| Output | Key | Settings |
|---|---|---|
| laptop | `Samsung Display Corp.\|0x41B3\|0x0000FF01` | disabled |
| Samsung 4K | description `Samsung Electric Company LS32D70xE HCNX801439` | 3840x2160@60, pos 0x0, scale 1.0, transform 0 |

Scale is 1.0 here, unlike every other profile. The make/model split is intentionally left
unresolved — `save` will determine it from live hardware.
