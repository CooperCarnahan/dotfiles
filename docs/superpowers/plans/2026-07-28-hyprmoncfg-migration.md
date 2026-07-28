# hyprmoncfg Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace hyprdynamicmonitors with hyprmoncfg as the sole Hyprland monitor profile manager, removing the Go-template layer and the chezmoi `.literal` mechanism entirely.

**Architecture:** hyprmoncfg stores three JSON profiles in `~/.config/hyprmoncfg/profiles/` (tracked by chezmoi) and generates `~/.config/hypr/monitors.lua` (chezmoi-ignored), which `hyprland.lua` loads via `require("monitors")`. The packaged `hyprmoncfgd` daemon auto-switches profiles on hotplug and lid events.

**Tech Stack:** hyprmoncfg 1.8.0 (Go, AUR), Hyprland 0.56.1 Lua config API, chezmoi, systemd user units.

**Spec:** `docs/superpowers/specs/2026-07-28-hyprmoncfg-migration-design.md`

## Global Constraints

- Exactly **three** profiles when done: `office`, `docked-home`, `undocked`. `hyprmoncfgd` scores **every** `*.json` in the profiles directory — no backups, experiments, or duplicates may remain.
- `peytonville` is **deliberately not created**. Do not author it from inferred values.
- The `docked-home` AOC `0x0001895E` display is recorded at **30Hz**, not 60Hz. This is intentional; see spec Appendix A.
- `hyprland.lua` is chezmoi-managed. **Always edit the chezmoi source** at `/home/cooper/.local/share/chezmoi/dot_config/hypr/hyprland.lua`, never the target directly.
- Never commit `~/.config/hypr/monitors.lua` — it is generated per-machine and causes cross-machine conflicts.
- All git commits in the chezmoi repo use the Claude profile: `git -c "include.path=~/.config/git/claude"`.
- Do not stage `dot_config/nvim/lua/plugins/clangd-extensions.lua` — it is an unrelated untracked file belonging to the user.

## File Structure

**Created:**
- `~/.config/hyprmoncfg/profiles/office.json` (+ `.conf`/`.lua` sidecars) — office profile, captured live
- `~/.config/hyprmoncfg/profiles/docked-home.json` — home dual-AOC profile
- `~/.config/hyprmoncfg/profiles/undocked.json` (+ sidecars) — laptop-only profile
- `~/.config/hypr/monitors.lua` — generated output, chezmoi-ignored
- `/home/cooper/.local/share/chezmoi/dot_config/hyprmoncfg/` — chezmoi source for the profile library

**Modified:**
- `/home/cooper/.local/share/chezmoi/dot_config/hypr/hyprland.lua:13` — `require("config.monitors")` → `require("monitors")`
- `/home/cooper/.local/share/chezmoi/.chezmoiignore:29-32` — retarget the ignore to the new generated path
- `/home/cooper/.local/share/chezmoi/.chezmoiignore:70-71` — remove hyprdynamicmonitors entries

**Deleted:**
- `/home/cooper/.local/share/chezmoi/dot_config/hyprdynamicmonitors/` — `modify_config.toml` + three `.literal` templates
- `~/.config/hyprdynamicmonitors/` — live config and templates
- `hyprdynamicmonitors-bin` AUR package

---

### Task 1: Capture the office profile from live hardware

The office HP displays are connected now. This is the only chance to capture them exactly.

**Files:**
- Create: `~/.config/hyprmoncfg/profiles/office.json`, `office.conf`, `office.lua`

**Interfaces:**
- Produces: profile named `office` with output keys `hp inc.|hp z27k g3|cn4322194x`, `hp inc.|hp z27k g3|cn432218ry`, and `samsung display corp.|0x41b3|0x0000ff01` (disabled).

- [ ] **Step 1: Confirm the expected hardware is live and no profiles exist yet**

```bash
hyprmoncfg monitors
hyprmoncfg profiles
```

Expected: three monitors listed — `eDP-1` state `off`, plus two `hp inc.|hp z27k g3|...` entries state `on`. Profiles output: `No saved profiles`.

If eDP-1 is not `off` or the HP displays are absent, STOP — you are not at the office dock.

- [ ] **Step 2: Save the profile**

```bash
hyprmoncfg save office
```

Expected: `Saved profile "office"`

- [ ] **Step 3: Verify the captured keys and disabled state**

```bash
python3 -c "
import json
d = json.load(open('/home/cooper/.config/hyprmoncfg/profiles/office.json'))
for o in d['outputs']:
    print(o['key'], 'enabled=' + str(o['enabled']), o['mode'], f\"pos={o['x']}x{o['y']}\", 'scale=' + str(o['scale']), 'transform=' + str(o['transform']))
"
```

Expected — three lines, order may vary. The two HP entries must match exactly:

```
hp inc.|hp z27k g3|cn4322194x enabled=True 3840x2160@60.00Hz pos=4800x-560 scale=1.5 transform=3
hp inc.|hp z27k g3|cn432218ry enabled=True 3840x2160@60.00Hz pos=6240x0 scale=1.5 transform=0
samsung display corp.|0x41b3|0x0000ff01 enabled=False ...
```

Note `cn4322194x` is the rotated display (`transform=3`). For the laptop, only
`enabled=False` matters — its recorded geometry varies by capture and is unused while
disabled, so do not assert on it.

- [ ] **Step 4: Verify the generated Lua sidecar parses and captured workspace pins**

```bash
luac -p /home/cooper/.config/hyprmoncfg/profiles/office.lua && echo VALID
grep -c 'hl.monitor' /home/cooper/.config/hyprmoncfg/profiles/office.lua
grep -c 'hl.workspace_rule' /home/cooper/.config/hyprmoncfg/profiles/office.lua
```

Expected: `VALID`, then `3`, then `2`.

If the workspace-rule count is `0`, the pins were not captured and Task 5 Step 8 will fail
later — stop and investigate rather than proceeding.

- [ ] **Step 5: Verify the office workspace mapping**

The office mapping is **inverted relative to home**: workspace 1 binds to `cn432218ry`, not
to the display that holds workspace 1 at the home dock. Confirm the captured rules match
what Hyprland currently has live.

```bash
python3 -c "
import json
d = json.load(open('/home/cooper/.config/hyprmoncfg/profiles/office.json'))
for r in d['workspaces']['rules']:
    print('workspace', r['workspace'], '->', r['output_key'], 'persistent=' + str(r['persistent']))
"
hyprctl workspacerules | grep -E 'Workspace rule|monitor:'
```

Expected: two rules, with workspace `1` bound to `hp inc.|hp z27k g3|cn432218ry`, and the
`hyprctl` output agreeing.

---

### Task 2: Install the docked-home profile from recorded values

The home AOC hardware is not reachable. Its exact values were captured earlier and are recorded here verbatim — no inference required.

**Files:**
- Create: `~/.config/hyprmoncfg/profiles/docked-home.json`

**Interfaces:**
- Consumes: nothing from Task 1.
- Produces: profile named `docked-home` with output keys `aoc|u2790b|0x0001947d`, `aoc|u2790b|0x0001895e`, and `samsung display corp.|0x41b3|0x0000ff01` (disabled).

- [ ] **Step 1: Write the profile JSON**

Write this exact content to `/home/cooper/.config/hyprmoncfg/profiles/docked-home.json`:

```json
{
  "name": "docked-home",
  "created_at": "2026-07-28T14:26:20.359167639Z",
  "updated_at": "2026-07-28T14:26:20.359323944Z",
  "outputs": [
    {
      "key": "aoc|u2790b|0x0001895e",
      "match_key": "aoc|u2790b|0x0001895e",
      "name": "DP-10",
      "description": "AOC U2790B 0x0001895E",
      "make": "AOC",
      "model": "U2790B",
      "serial": "0x0001895E",
      "enabled": true,
      "mode": "3840x2160@30.00Hz",
      "width": 3840,
      "height": 2160,
      "refresh": 30,
      "x": 720,
      "y": -110,
      "scale": 1.5,
      "transform": 1,
      "bitdepth": 8,
      "cm": "srgb",
      "sdr_brightness": 1,
      "sdr_saturation": 1,
      "sdr_min_luminance": 0.2,
      "sdr_max_luminance": 80,
      "min_luminance": 0
    },
    {
      "key": "aoc|u2790b|0x0001947d",
      "match_key": "aoc|u2790b|0x0001947d",
      "name": "DP-8",
      "description": "AOC U2790B 0x0001947D",
      "make": "AOC",
      "model": "U2790B",
      "serial": "0x0001947D",
      "enabled": true,
      "mode": "3840x2160@60.00Hz",
      "width": 3840,
      "height": 2160,
      "refresh": 60,
      "x": 2160,
      "y": 450,
      "scale": 1.5,
      "transform": 0,
      "bitdepth": 8,
      "cm": "srgb",
      "sdr_brightness": 1,
      "sdr_saturation": 1,
      "sdr_min_luminance": 0.2,
      "sdr_max_luminance": 80,
      "min_luminance": 0
    },
    {
      "key": "samsung display corp.|0x41b3|0x0000ff01",
      "match_key": "samsung display corp.|0x41b3|0x0000ff01",
      "name": "eDP-1",
      "description": "Samsung Display Corp. 0x41B3 0x0000FF01",
      "make": "Samsung Display Corp.",
      "model": "0x41B3",
      "serial": "0x0000FF01",
      "enabled": false,
      "mode": "2880x1800@120.00Hz",
      "width": 2880,
      "height": 1800,
      "refresh": 120.001,
      "x": 4720,
      "y": 0,
      "scale": 2,
      "transform": 0,
      "bitdepth": 8,
      "cm": "srgb",
      "sdr_brightness": 1,
      "sdr_saturation": 1,
      "sdr_min_luminance": 0.2,
      "sdr_max_luminance": 80,
      "min_luminance": 0
    }
  ],
  "workspaces": {
    "enabled": true,
    "strategy": "manual",
    "max_workspaces": 9,
    "group_size": 3,
    "monitor_order": [
      "aoc|u2790b|0x0001895e",
      "aoc|u2790b|0x0001947d",
      "samsung display corp.|0x41b3|0x0000ff01"
    ],
    "rules": [
      {
        "workspace": "1",
        "output_key": "aoc|u2790b|0x0001947d",
        "output_name": "DP-8",
        "persistent": true
      },
      {
        "workspace": "2",
        "output_key": "aoc|u2790b|0x0001895e",
        "output_name": "DP-10",
        "persistent": true
      }
    ]
  },
  "exec": ""
}
```

- [ ] **Step 2: Verify hyprmoncfg parses and lists it**

```bash
hyprmoncfg profiles
```

Expected: both `docked-home` and `office` appear. If `docked-home` is absent or an error is printed, the JSON is malformed.

- [ ] **Step 3: Verify the 30Hz value survived**

```bash
python3 -c "
import json
d = json.load(open('/home/cooper/.config/hyprmoncfg/profiles/docked-home.json'))
o = [x for x in d['outputs'] if x['key'] == 'aoc|u2790b|0x0001895e'][0]
print('refresh:', o['refresh'], '| mode:', o['mode'])
assert o['refresh'] == 30, 'must remain 30Hz per spec'
print('OK')
"
```

Expected: `refresh: 30 | mode: 3840x2160@30.00Hz` then `OK`.

---

### Task 3: Capture the undocked profile

Requires physically undocking. hyprdynamicmonitors is still the active daemon at this point and will switch to its own `undocked` profile — that is expected and harmless.

**Files:**
- Create: `~/.config/hyprmoncfg/profiles/undocked.json`, `undocked.conf`, `undocked.lua`

**Interfaces:**
- Produces: profile named `undocked` with a single enabled output `samsung display corp.|0x41b3|0x0000ff01`.

- [ ] **Step 1: Undock the laptop, then confirm only the internal panel is active**

```bash
hyprmoncfg monitors
```

Expected: exactly one line, `eDP-1` with state `on`. If any external display still appears, wait for the dock to fully detach and re-run.

- [ ] **Step 2: Save the profile**

```bash
hyprmoncfg save undocked
```

Expected: `Saved profile "undocked"`

- [ ] **Step 3: Verify it captured a single enabled output**

```bash
python3 -c "
import json
d = json.load(open('/home/cooper/.config/hyprmoncfg/profiles/undocked.json'))
en = [o for o in d['outputs'] if o['enabled']]
print('enabled outputs:', [o['key'] for o in en])
assert len(en) == 1 and en[0]['key'] == 'samsung display corp.|0x41b3|0x0000ff01'
print('OK')
"
```

Expected: one key listed, then `OK`.

- [ ] **Step 4: Redock, and confirm exactly three profiles exist**

```bash
ls -1 /home/cooper/.config/hyprmoncfg/profiles/*.json | wc -l
ls -1 /home/cooper/.config/hyprmoncfg/profiles/*.json
```

Expected: `3`, then exactly `docked-home.json`, `office.json`, `undocked.json`.

If any other `*.json` exists, delete it — the daemon scores every file in this directory.

---

### Task 4: Track the profile library in chezmoi

Do this **before** the cutover so the captured profiles are versioned and recoverable if anything later goes wrong.

**Files:**
- Create: `/home/cooper/.local/share/chezmoi/dot_config/hyprmoncfg/`

- [ ] **Step 1: Add the directory**

```bash
chezmoi add ~/.config/hyprmoncfg
```

- [ ] **Step 2: Verify the profiles landed in the chezmoi source**

```bash
ls -1 /home/cooper/.local/share/chezmoi/dot_config/hyprmoncfg/profiles/
```

Expected: the three `.json` files only.

**Amended during execution (user decision).** `chezmoi add` initially pulled in the
generated `.conf`/`.lua` sidecars too, and the StyLua pre-commit hook then rewrote the
`.lua` files to tabs while hyprmoncfg keeps regenerating them with 2-space indentation —
permanent `chezmoi status` drift. The sidecars are now `.chezmoiignore`d.

This deviates from upstream's suggestion to commit the whole directory. The user judged the
sidecars worthless for this setup: `.conf` is legacy hyprlang that a Lua config cannot
source, `docked-home` has no sidecars at all (hand-authored off-site), and the `.json` is
the only file hyprmoncfg and hyprmoncfgd actually read.

- [ ] **Step 3: Confirm no unrelated files are staged**

```bash
cd /home/cooper/.local/share/chezmoi && git status --short
```

Expected: only `dot_config/hyprmoncfg/` entries as untracked/added, plus the pre-existing untracked `dot_config/nvim/lua/plugins/clangd-extensions.lua`, which must NOT be staged.

- [ ] **Step 4: Commit**

```bash
cd /home/cooper/.local/share/chezmoi
git -c "include.path=~/.config/git/claude" add dot_config/hyprmoncfg
git -c "include.path=~/.config/git/claude" commit -m "feat(hypr): track hyprmoncfg profile library

Three profiles captured from live hardware: office, docked-home, undocked.
Tracked before cutover so they are recoverable independently of the
hyprdynamicmonitors removal.

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Cut over to hyprmoncfg as the config source

Order matters here. `monitors.lua` must exist **before** `hyprland.lua` requires it, or any Hyprland reload fails with a module-not-found error.

**Files:**
- Create: `~/.config/hypr/monitors.lua` (seeded, then regenerated)
- Modify: `/home/cooper/.local/share/chezmoi/dot_config/hypr/hyprland.lua:13`
- Modify: `/home/cooper/.local/share/chezmoi/.chezmoiignore:29-32`

- [ ] **Step 1: Stop and disable both hyprdynamicmonitors units**

```bash
systemctl --user disable --now hyprdynamicmonitors.service
systemctl --user disable --now hyprdynamicmonitors-prepare.service
systemctl --user is-active hyprdynamicmonitors.service || echo "STOPPED"
```

Expected: `inactive` followed by `STOPPED`.

- [ ] **Step 2: Seed the new target with the current working config**

This guarantees `require("monitors")` resolves even before hyprmoncfg writes it.

```bash
cp /home/cooper/.config/hypr/config/monitors.lua /home/cooper/.config/hypr/monitors.lua
luac -p /home/cooper/.config/hypr/monitors.lua && echo VALID
```

Expected: `VALID`.

- [ ] **Step 3: Retarget the require in the chezmoi source**

In `/home/cooper/.local/share/chezmoi/dot_config/hypr/hyprland.lua`, change line 13:

```lua
require("config.monitors")
```

to:

```lua
require("monitors")
```

- [ ] **Step 4: Retarget the ignore rule**

In `/home/cooper/.local/share/chezmoi/.chezmoiignore`, replace lines 29-32:

```
# hyprdynamicmonitors writes this at runtime based on the matched profile.
# Templates live under .config/hyprdynamicmonitors/hyprconfigs/; the rendered
# output is machine state, not dotfile content.
.config/hypr/config/monitors.lua
```

with:

```
# hyprmoncfg regenerates this on every apply from the matched JSON profile.
# Profiles live under .config/hyprmoncfg/profiles/; this rendered output is
# machine state, not dotfile content, and differs per connected hardware.
.config/hypr/monitors.lua
```

- [ ] **Step 5: Apply the hyprland.lua change to the target**

Targeted apply avoids touching anything else.

```bash
chezmoi apply ~/.config/hypr/hyprland.lua
grep -n 'require("monitors")' /home/cooper/.config/hypr/hyprland.lua
```

Expected: line 13 shown as `require("monitors")`.

- [ ] **Step 6: Reload Hyprland and confirm displays are unchanged**

```bash
hyprctl reload
hyprmoncfg monitors
```

Expected: same three monitors as Task 1 Step 1 — eDP-1 `off`, both HP displays `on`. If the screen goes blank or monitors change, restore with `cp /home/cooper/.config/hypr/config/monitors.lua /home/cooper/.config/hypr/monitors.lua && hyprctl reload`.

- [ ] **Step 7: Apply the office profile through hyprmoncfg**

This exercises the include-chain verification, the Lua writer, and apply-verification together.

```bash
hyprmoncfg apply office --confirm-timeout 0
```

Expected: `Applied profile "office"`, exit code 0, and no `is not included by` error. That
error would mean Step 3/5 did not take effect.

**`--confirm-timeout 0` is required for non-interactive use.** Discovered during execution:
bare `hyprmoncfg apply` prompts `Keep this configuration? [y/N] (auto-revert in 10s)`. With
no TTY on stdin it reads EOF and exits non-zero, printing usage — even though it already
wrote the config and applied it successfully. The flag disables the confirmation so the
command is deterministic. Interactively, answering the prompt is the safer choice, since
auto-revert protects against a layout that leaves you with no usable display.

- [ ] **Step 8: Verify hyprmoncfg now owns the generated file**

```bash
head -3 /home/cooper/.config/hypr/monitors.lua
luac -p /home/cooper/.config/hypr/monitors.lua && echo VALID
grep -c 'hl.workspace_rule' /home/cooper/.config/hypr/monitors.lua
```

Expected: a `hyprmoncfg` generation header, `VALID`, and a non-zero workspace-rule count.

- [ ] **Step 9: Commit the config-source changes**

```bash
cd /home/cooper/.local/share/chezmoi
git -c "include.path=~/.config/git/claude" add dot_config/hypr/hyprland.lua .chezmoiignore
git -c "include.path=~/.config/git/claude" commit -m "refactor(hypr): load monitors.lua from hyprmoncfg

Point hyprland.lua at hyprmoncfg's documented default target and retarget
the ignore rule to the new generated path. config/ now holds only authored,
tracked modules; generated state lives at the top level.

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: Enable the daemon and prove auto-switching

This is the gate. Do not proceed to removal until a real hotplug cycle switches profiles.

- [ ] **Step 1: Enable and start the daemon**

```bash
systemctl --user daemon-reload
systemctl --user enable --now hyprmoncfgd
systemctl --user is-active hyprmoncfgd
```

Expected: `active`.

- [ ] **Step 2: Undock and confirm the daemon switches to `undocked`**

Physically undock, wait ~3 seconds (the daemon debounces 1.2s), then:

```bash
hyprmoncfg monitors
journalctl --user -u hyprmoncfgd -n 15 --no-pager
```

Expected: only `eDP-1` active, and the journal shows a profile application.

- [ ] **Step 3: Redock and confirm it switches back to `office`**

Physically redock, wait ~3 seconds, then:

```bash
hyprmoncfg monitors
hyprctl monitors -j | python3 -c "
import json, sys
mons = {m['name']: m for m in json.load(sys.stdin)}
print('active:', sorted(mons))
"
```

Expected: both HP displays active again, eDP-1 disabled.

- [ ] **Step 4: Confirm workspace pins survived the cycle**

```bash
hyprctl workspacerules
```

Expected: persistent rules bound to the HP display selectors.

If any of these steps fail, STOP. Re-enable hyprdynamicmonitors (`systemctl --user enable --now hyprdynamicmonitors.service`) and revert Task 5 Step 3 before continuing.

---

### Task 7: Remove hyprdynamicmonitors completely

Only run this after Task 6 passed.

**Files:**
- Delete: `~/.config/hyprdynamicmonitors/`
- Delete: `/home/cooper/.local/share/chezmoi/dot_config/hyprdynamicmonitors/`
- Modify: `/home/cooper/.local/share/chezmoi/.chezmoiignore` — remove the hyprdynamicmonitors entries

- [ ] **Step 1: Remove the AUR package**

Requires root; run interactively.

```bash
sudo pacman -Rns hyprdynamicmonitors-bin
```

Expected: removal succeeds and takes both systemd unit files with it.

- [ ] **Step 2: Confirm the units are gone**

```bash
systemctl --user list-unit-files | grep -i hyprdynamic || echo "UNITS GONE"
```

Expected: `UNITS GONE`.

- [ ] **Step 3: Remove the live config directory**

```bash
rm -rf /home/cooper/.config/hyprdynamicmonitors
rm -f /home/cooper/.config/hypr/config/monitors.lua
```

The second command removes the now-orphaned generated file from the old location; nothing requires it after Task 5.

- [ ] **Step 4: Remove the chezmoi source directory**

```bash
rm -rf /home/cooper/.local/share/chezmoi/dot_config/hyprdynamicmonitors
```

- [ ] **Step 5: Remove the ignore entries**

In `/home/cooper/.local/share/chezmoi/.chezmoiignore`, delete these two lines from the Linux-GUI block:

```
.config/hyprdynamicmonitors
.config/hyprdynamicmonitors/**
```

- [ ] **Step 5b: Remove the package from the AUR bootstrap list**

Discovered during execution and NOT in the original plan. Without this, the next
`chezmoi apply` on this or any other machine silently reinstalls the tool being removed.

In `/home/cooper/.local/share/chezmoi/.chezmoiscripts/run_onchange_after_setup_aur_packages.sh.tmpl`,
remove the `hyprdynamicmonitors-bin` entry and add `hyprmoncfg` in its place, keeping the
list alphabetically sorted:

```
    "handy-bin"
-   "hyprdynamicmonitors-bin"
+   "hyprmoncfg"
    "maplemono-nf-unhinted"
```

⚠️ That file has an unrelated uncommitted change belonging to the user (removal of `tlp`
and `tlpui`). Leave it in the working tree and do NOT include it in this task's commit —
stage the file only if the two changes can be separated; otherwise ask.

- [ ] **Step 6: Verify no references remain**

```bash
grep -rn 'hyprdynamicmonitors' /home/cooper/.local/share/chezmoi --exclude-dir=.git --exclude-dir=docs || echo "NO REFERENCES"
```

Expected: `NO REFERENCES`. Matches under `docs/` are historical spec text and are expected
to remain. This grep is what catches the AUR-list entry if Step 5b was skipped.

- [ ] **Step 7: Verify chezmoi is consistent**

```bash
chezmoi status
chezmoi apply --dry-run --verbose 2>&1 | head -20
```

Expected: no pending changes to hypr or hyprmoncfg files. The untracked nvim file may still appear and must be left alone.

- [ ] **Step 8: Commit**

```bash
cd /home/cooper/.local/share/chezmoi
git -c "include.path=~/.config/git/claude" add -A dot_config/hyprdynamicmonitors .chezmoiignore
git -c "include.path=~/.config/git/claude" commit -m "chore(hypr): remove hyprdynamicmonitors

Superseded by hyprmoncfg, which emits native Lua, verifies its include
chain, and ships a hotplug daemon. Removes the Go-template layer, the
chezmoi .literal mechanism, the modify_ template that silently dropped
profiles on a fresh machine, and the UPower/D-Bus dependency.

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

## Post-migration notes

- **peytonville:** on the next visit, run `hyprmoncfg save peytonville` then `chezmoi re-add ~/.config/hyprmoncfg`. Cross-check against spec Appendix A — expect scale `1.0` and position `0x0`.
- **After any future profile change:** `chezmoi re-add ~/.config/hyprmoncfg` and commit, or the change stays local only.
- **Open question, unrelated to this migration:** the home AOC `0x0001895E` runs at 30Hz where the template requested 60Hz. Likely DisplayPort bandwidth at 4K with rotation. Investigate separately; the profile records 30Hz deliberately.
