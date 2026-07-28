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

Exactly four profiles. No backups, experiments, or duplicates may remain in the profiles
directory: `hyprmoncfgd` scores **every** `*.json` in it, and stale files silently compete
during matching.

| Profile | Hardware | Provenance | Key confidence |
|---|---|---|---|
| `office` | `hp inc.\|hp z27k g3\|cn4322194x` + `...\|cn432218ry`, eDP-1 disabled | `hyprmoncfg save` against live hardware | exact |
| `docked-home` | `aoc\|u2790b\|0x0001947d` + `...\|0x0001895e`, eDP-1 disabled | Captured earlier via `save`; exact fields already recorded | exact |
| `undocked` | `samsung display corp.\|0x41b3\|0x0000ff01` only | `save` after undocking, or authored from these known fields | exact |
| `peytonville` | Samsung LS32D70xE + eDP-1 disabled | Hand-authored JSON | **serial exact, make/model split inferred** |

### The peytonville inference

Only HDM's concatenated description is available: `Samsung Electric Company LS32D70xE HCNX801439`.
The serial is unambiguous (last token). The make/model split is inferred as
make `Samsung Electric Company`, model `LS32D70xE`. The same inference applied to the HP
displays was confirmed correct once that hardware was live, which raises confidence but does
not prove this case.

Failure mode is benign and self-correcting: a wrong key means the profile does not
auto-match, not that anything breaks. On site, `hyprmoncfg save peytonville` followed by
`chezmoi re-add ~/.config/hyprmoncfg` corrects it permanently.

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
2. Author `docked-home`, `undocked`, and `peytonville` JSON in the profiles directory.
   Confirm exactly four `*.json` files exist.
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

A mis-keyed `peytonville` is not a rollback scenario; it degrades to "no auto-match" and is
fixed in place on site.

## Verification

- `luac -p` passes on the generated `monitors.lua`
- `hyprctl monitors` reflects the intended layout, with eDP-1 disabled where specified
- Workspaces 1 and 2 land on the intended displays
- A physical undock/redock triggers the daemon and applies the correct profile
- `chezmoi status` is clean and `chezmoi apply --dry-run` shows no unintended changes
- Exactly four `*.json` files in `~/.config/hyprmoncfg/profiles/`

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
