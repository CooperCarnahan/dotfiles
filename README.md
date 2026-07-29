# dotfiles

Cross-platform [chezmoi](https://chezmoi.io) dotfiles for Windows, macOS, and Linux
(Arch/CachyOS + Debian/Ubuntu).

## Design

- **[mise](https://mise.jdx.dev) is the package authority on unix.** One manifest —
  `dot_config/mise/config.toml.tmpl` — declares both the dev CLI toolchain (`[tools]`: `nu`,
  ripgrep, node, uv, `claude`, and ~50 more) and the system packages
  (`[bootstrap.packages]`: pacman/apt/brew/brew-cask — OS/build packages and GUI apps).
- **Scripts cover only what mise can't:** AUR packages via paru
  (`run_onchange_after_setup_aur_packages`) and the whole Windows layer (winget + scoop —
  mise has no backends for those).
- **[Topgrade](https://github.com/topgrade-rs/topgrade) owns updates.** It runs chezmoi first,
  then upgrades the system package manager, mise tools, and the other managers it detects.
  Chezmoi only provisions declared state and never calls Topgrade, so the flow cannot recurse.

App-owned JSON configs (`~/.claude/settings.json`, Windows PowerToys/Terminal) use native
`chezmoi:modify-template` merges. They preserve unknown/runtime keys and emit the original
bytes when the managed values already match, so application key ordering creates neither
diff noise nor apply churn. No external interpreter is required during the file phase.

On unix the bootstrap runs almost entirely in the `after` phase
(`run_onchange_after_install_mise_toolchain`): `mise bootstrap packages apply` installs the
system packages, then `mise install` materializes the toolchain — neither can happen earlier,
because both read `~/.config/mise/config.toml`, which the file phase itself puts in place.
(Windows keeps its mise install in the `before` script, driven by scoop.)

## First run on a new machine

The only manual prerequisite is mise; chezmoi comes through it. Chezmoi clones this repo with
its **built-in git**, so a system `git` is *not* required for the initial clone — `mise
bootstrap packages apply` installs git (and everything else) during the first apply.

### macOS / Linux

```sh
curl https://mise.run | sh
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
mise use -g chezmoi
chezmoi init --apply CooperCarnahan
```

`mise use -g` installs chezmoi and writes a minimal `~/.config/mise/config.toml`; the file
phase replaces it with this repo's full manifest.

The `PATH` export makes the newly installed chezmoi shim visible immediately. A login shell
will not have that directory yet on a fresh box because it did not exist at login. This is the
same invocation the Podman full-tier test validates.

- **macOS:** no Homebrew install needed — mise's `brew`/`brew-cask` backends install formulas
  and casks directly (one sudo prompt to create `/opt/homebrew` on a brew-less mac). No
  chezmoi prompts. If you'll compile anything (cargo builds, etc.), run
  `xcode-select --install` first — nothing in the bootstrap pulls the CLT anymore.
- **Arch / CachyOS:** prompts **"Is this a headless machine?"** (defaults to `false` on
  Arch/CachyOS). The pacman set — plus, on non-headless boxes, the Wayland desktop stack +
  GDM — applies via `mise bootstrap packages` in the `after` phase; AUR packages follow via
  paru in `setup_aur_packages`.
- **Debian / Ubuntu:** treated as a headless server. The apt build toolchain applies via
  `mise bootstrap packages` in the `after` phase. (No desktop packages.)

### Windows

```powershell
winget install twpayne.chezmoi

# Only if enabling the OpenSSH server — init reads the SSH key from 1Password.
winget install AgileBits.1Password AgileBits.1Password.CLI

chezmoi init --apply CooperCarnahan
```

Git is not a prerequisite: chezmoi clones with its built-in git, and `Microsoft.Git`
installs during the first apply.

Four prompts, all asked once at `init` and persisted to `[data]`:

- **"Is this a work machine?"** — `true` skips the personal apps (1Password, NordVPN,
  Tailscale, Claude, Zen, GlazeWM).
- **"Apply Windows tweaks…?"** — defaults to `not work`. Disables telemetry, ads,
  suggestions, Bing/Copilot/Recall; enables End Task on taskbar right-click, known file
  extensions, hidden files; opens Explorer to This PC.
- **"Remove preinstalled apps…?"** — defaults to `not work`. Uninstalls 82 apps
  (upstream's curated selection **minus Teams (New) and To Do**).
- **"Enable the OpenSSH server…?"** — defaults to `false`. Installs the OpenSSH.Server
  capability, enables `sshd`, and writes the inter-computer public key (read from
  1Password at init) to `C:\ProgramData\ssh\administrators_authorized_keys` with the ACL
  sshd requires.

Tweaks and app removal are separate consents — one changes settings, the other uninstalls
software. Both share a single [Win11Debloat](https://github.com/Raphire/Win11Debloat)
invocation, pinned by version + sha256 in `.chezmoidata/packages.toml`.

Dark mode and Developer Mode stay local rather than delegated, so each setting has one
owner. Rationale for that split, and for avoiding `-RunDefaults`, is in the script
comments.

Package lists live in **`.chezmoidata/packages.toml`** (winget / msstore / scoop, with
`tags = ["personal"]` for non-work-only entries). Linux/macOS packages stay in
`dot_config/mise/config.toml.tmpl` — that is a real manifest mise consumes, not data.

- The before-script installs winget packages, then Scoop, then mise, then the toolchain.
- **If the apply stops with `mise not found on PATH`:** Scoop just added mise's shim but this
  shell hasn't picked it up. Open a new terminal and run `chezmoi apply` again.
- **Expect up to two UAC prompts** on a fresh box (one for system settings, one for
  Win11Debloat), and none once the machine has converged. This is not a fully unattended
  bootstrap.
- **If `sshServer` is on and OpenSSH isn't installed yet,** apply returns *before* sshd is
  ready — `Add-WindowsCapability` continues in a detached elevated window. Re-run
  `chezmoi apply` to confirm convergence.
- **`sshServer` needs `op` before `init`** — the key is read from 1Password at init, but
  `op` installs during apply. Init fails with an actionable error if it's missing. Requires
  the desktop app's CLI integration (Settings > Developer).

#### Updating an existing Windows machine

`.chezmoi.toml.tmpl` is only evaluated during `init`, so new config keys do not appear on
a plain `apply`/`update`:

```powershell
chezmoi update      # pull the new source state
chezmoi init        # re-prompt; promptBoolOnce keeps existing answers
chezmoi apply
```

Consumers read the new keys through `dig` with safe defaults, so an un-migrated machine
degrades to "features off" rather than failing — but it will not pick them up until
`init` is re-run.

## How the bootstrap runs

Every platform follows the same skeleton: the file phase uses dependency-free native
modifiers and writes the mise/Topgrade manifests, then the after phase provisions packages
and tools. Windows installs its application packages and mise in the before phase so those
applications exist before their configs are applied. Fastfetch is a plain, lexically last
after hook, so it is the actual completion summary.

```mermaid
flowchart TD
    A["Manual: install mise → chezmoi<br/>curl mise.run · mise use -g chezmoi<br/>(Windows: winget twpayne.chezmoi)"]
    A --> B["chezmoi init --apply CooperCarnahan<br/>built-in git clones the repo"]
    B --> C{{".chezmoi.toml.tmpl prompts"}}
    C -->|Windows| Pw["work? · windowsTweaks? · removeApps? · sshServer?"]
    C -->|Linux| Pl["headless?"]
    C -->|macOS| Pm["no prompts"]

    subgraph BEFORE["BEFORE phase"]
      direction TB
      Pw --> Bw["windows-packages.ps1<br/>winget + msstore + scoop from .chezmoidata/packages.toml<br/>mise install · fails non-zero on any package error"]
    end

    Bw --> Main
    Pl --> Main
    Pm --> Main
    Main["FILE phase — apply targets + externals<br/>native modify templates merge app-owned JSON<br/>writes mise + Topgrade configuration<br/>extracts pinned Win11Debloat (if tweaks or removeApps)"]
    Main --> Sys["run_windows-system.ps1 (Windows, ALWAYS runs)<br/>HOME · XDG · PATH · dark mode<br/>one elevated helper: dev mode + OpenSSH"]

    subgraph AFTER["AFTER phase — packages + toolchain + hooks"]
      direction TB
      Tl["after_install_mise_toolchain.sh (unix)<br/>install mise → bootstrap packages apply → mise install → uv apprise"]
      Nu["after_reconcile-nushell-autoload.nu<br/>(needs nu — mise-provided, now present)"]
      Aur["after_setup_aur_packages.sh (arch)<br/>paru bootstrap · AUR pkgs · mako disable"]
      Cc["after_setup_claude_code.sh<br/>(non-Windows) plugins + MCP"]
      Gd["after_setup_gdm.sh + install-system-config.sh<br/>(Linux desktop only)"]
      Wd["after_windows-debloat.ps1 (Windows, if tweaks or removeApps)<br/>elevated Win11Debloat · build-gated flags · postcondition-checked"]
      Ff["zz-fastfetch.nu<br/>final summary on every apply"]
    end
    Main --> Tl
    Tl --> Nu
    Nu --> Aur
    Aur --> Cc
    Cc --> Gd
    Gd --> Wd
    Wd --> Ff
```

Two Windows scripts deliberately differ in kind. `run_windows-system.ps1` is `run_`
(**always** runs): it launches a detached elevated helper, and under `run_onchange_`
chezmoi would record success from the parent's exit and skip the script forever after,
so its read-guards would never reconcile anything. `run_onchange_after_windows-debloat.ps1`
is `run_onchange_` and throws on every failure path — a warn-and-continue would be stored
as success and never retried.

## Testing

Podman-based bootstrap tests for Arch and Debian live in `tests/podman/`
(see [its README](tests/podman/README.md)):

```sh
tests/podman/run.sh                     # smoke tier: template render + apply asserts (~2 min)
tests/podman/run.sh --tier full debian  # full tier: the real fresh-system bootstrap
```

CI runs the smoke tier on every push/PR and the full tier weekly.

## Keeping a machine current

`chezmoi apply` only **provisions**: it ensures declared packages and tools are present and
applies configuration. It does not upgrade already-installed software. Editing
`[bootstrap.packages]` or `[tools]` changes the manifest hash and re-runs provisioning.

Run `mise run update` to update the machine; it asks for confirmation before starting the
potentially lengthy Topgrade pass. The managed Topgrade config runs chezmoi first, then the
detected system and language package managers. Because chezmoi never calls Topgrade, this
one-way flow cannot recurse. Calling `topgrade` directly skips the wrapper confirmation. For
unattended agents or scripts:

```sh
mise run update-unattended
```

This passes `--yes --no-ask-retry`. On Arch/CachyOS, Topgrade is configured to use `paru`, so
repository and AUR packages participate in one full transaction rather than a partial upgrade.
`mise bootstrap` remains a local converge command: packages, tools, then `chezmoi apply`
without fetching or upgrading anything.

## Layout

| Path | Purpose |
|---|---|
| `.chezmoi.toml.tmpl` | Prompts, data, interpreters, structural diff + JSON normalization |
| `.chezmoiscripts/` | Per-OS `run_onchange_*` bootstrap scripts (system packages + mise) |
| `.chezmoitemplates/` | Desired JSON plus the native semantic merge helper |
| `.chezmoiignore` | OS/role-gated ignore rules |
| `.chezmoiversion` | Minimum chezmoi version (uses `promptBoolOnce`, `includeTemplate`, `lookPath`) |
| `dot_config/mise/config.toml.tmpl` | The dev toolchain manifest |
| `dot_config/topgrade.toml.tmpl` | One-way update orchestration and per-OS manager policy |
