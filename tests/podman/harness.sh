#!/usr/bin/env bash
# In-container test driver. Invoked by run.sh with the repo mounted read-only
# at /src/dotfiles.
#
#   smoke — tooling (chezmoi/mise/nushell) is baked into the image; applies the
#           source with run scripts excluded and asserts on rendered output.
#   full  — starts from a fresh-system image; installs mise and seeds chezmoi
#           through it (the README one-liner), then applies WITH
#           run scripts so the actual package-provisioning path
#           (mise bootstrap packages + AUR script) is exercised end-to-end.
set -euo pipefail

usage() {
    echo "usage: harness.sh [--tier smoke|full]" >&2
    exit 2
}

tier=smoke
while [ $# -gt 0 ]; do
    case "$1" in
        --tier)
            tier=${2:?"--tier needs an argument"}
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

case "$tier" in
    smoke | full) ;;
    *) usage ;;
esac

repo=/src/dotfiles

# Shims first so mise-provisioned tools used by after hooks resolve as soon as
# they exist.
# The dir may not exist yet in the full tier — harmless.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# Signals test context to chezmoi run scripts (e.g. skips the network-heavy
# Claude Code plugin setup).
export DOTFILES_TEST=1

if ! command -v chezmoi >/dev/null 2>&1; then
    # Full tier: reproduce the README one-liner — install mise, then seed only
    # chezmoi. Native modify templates have no pre-file-phase dependencies.
    curl -fsSL https://mise.run | sh
    mise use -g chezmoi
fi

# Generate the config through the REAL .chezmoi.toml.tmpl path: osid comes from
# the container's actual /etc/os-release; only the interactive prompt is
# answered up front. --no-tty makes any unexpected prompt fail loudly.
# NB: chezmoi keys --promptBool pairs by the PROMPT TEXT (not the variable
# name) — this string must match the promptBoolOnce call in .chezmoi.toml.tmpl.
# The `work` prompt is Windows-only, so no pair is needed for it here.
chezmoi init --source "$repo" --no-tty \
    --promptBool "Is this a headless machine (no desktop / Wayland session)?=true"

if [ "$tier" = smoke ]; then
    chezmoi apply --source "$repo" --force --no-tty \
        --refresh-externals=never --exclude scripts
else
    chezmoi apply --source "$repo" --force --no-tty
fi

export DOTFILES_TEST_TIER="$tier"
bats "$repo/tests/bats/smoke.bats"
if [ "$tier" = full ]; then
    bats "$repo/tests/bats/full.bats"
fi

# shellcheck disable=SC1091
echo "dotfiles $tier tier passed ($(. /etc/os-release && echo "$ID"))"
