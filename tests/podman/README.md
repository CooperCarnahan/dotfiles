# Podman Dotfiles Tests

Headless, repeatable validation that a fresh Arch or Debian system can apply
this chezmoi source — two tiers over the same infrastructure:

| Tier | Image stage | Run scripts | What it proves | Wall time |
|---|---|---|---|---|
| **smoke** (default) | `smoke` (chezmoi/mise/nushell baked in) | excluded | Templates render with the container's REAL distro identity (`linux-arch` / `linux-debian`), headless ignore gates hold, nushell/mise/git configs land and parse, second apply is idempotent | ~2 min after first image build |
| **full** | `base` (fresh system; only bats preinstalled) | **included** | The actual bootstrap: `chezmoi init` → package-install scripts (pacman/paru or apt) → mise toolchain → after-scripts. The real "new machine" path, end to end | 30 min+ (network heavy) |

Both tiers generate the config through the real `.chezmoi.toml.tmpl` path via
`chezmoi init --promptBool headless=true,work=false` — no synthetic
`--override-data`. `pushoverUrl` resolves empty naturally (`op` is not in the
container).

## Usage

```sh
tests/podman/run.sh                      # smoke, both distros
tests/podman/run.sh --tier smoke arch    # smoke, arch only
tests/podman/run.sh --tier full debian   # full bootstrap, debian only
tests/podman/run.sh --shell debian       # interactive debug shell (smoke image)
```

Inside a `--shell` session the repo is mounted read-only at `/src/dotfiles`;
run `bash /src/dotfiles/tests/podman/harness.sh --tier smoke` or individual
suites with `bats /src/dotfiles/tests/bats/smoke.bats`.

`MISE_GITHUB_TOKEN` authenticates mise's GitHub API calls (aqua/github
backends) — both at image-build time (fed in as a podman build secret) and
inside the container at runtime. Unauthenticated works until per-IP rate
limits bite; for the full tier's ~50-tool `mise install` a token is strongly
recommended:

```sh
MISE_GITHUB_TOKEN=$(gh auth token) tests/podman/run.sh --tier full debian
```

## Layout

- `run.sh` — host CLI: builds the tier-appropriate image stage, mounts the
  repo read-only, launches `harness.sh` in the container.
- `harness.sh` — in-container driver: installs chezmoi if absent (full tier),
  `chezmoi init` + `apply`, then runs the bats suites.
- `Containerfile.{arch,debian}` — two stages: `base` (fresh system + bats) and
  `smoke` (`FROM base`, tooling baked into cached layers).
- `../bats/smoke.bats` — core assertions, run in both tiers.
- `../bats/full.bats` — bootstrap assertions (mise toolchain materialized,
  paru/build-essential present, externals fetched), full tier only.

## CI

- `.github/workflows/test-smoke.yml` — smoke matrix (debian, arch) on push to
  master and on PRs.
- `.github/workflows/test-full.yml` — full matrix weekly + `workflow_dispatch`
  (optional single-distro input).

## Design notes / accepted limitations

- **Smoke excludes ALL run scripts** (`--exclude scripts`): chezmoi can only
  exclude by entry class, not per-script. The headless-safe after-scripts
  (e.g. `reconcile-nushell-autoload`) are exercised by the full tier instead.
- **Run scripts see `DOTFILES_TEST=1`** — `setup_claude_code` short-circuits on
  it (network-heavy plugin installs don't belong in CI).
- **Idempotency check uses `--exclude scripts` in both tiers**: file-state
  idempotency is the contract; re-running 30-minute installs proves nothing.
- **`archlinux:latest` covers the `linux-arch` branch**; the real desktop is
  CachyOS, which shares the arch code paths via the osid gates — CachyOS
  repos/kernel are untested here.
- **systemd and GUI/session setup are out of scope** — those targets are
  already excluded by the headless gates in `.chezmoiignore` (and the smoke
  suite asserts they stayed excluded).
