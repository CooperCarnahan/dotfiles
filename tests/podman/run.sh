#!/usr/bin/env bash
# Host-side CLI for the podman dotfiles test harness.
#
#   run.sh                          # smoke tier, both distros
#   run.sh --tier full debian      # full bootstrap tier, debian only
#   run.sh --shell arch            # interactive debug shell in the smoke image
set -euo pipefail

usage() {
    echo "usage: $0 [--tier smoke|full] [--shell] [debian|arch|all]" >&2
    exit 2
}

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo=$(cd -- "$script_dir/../.." && pwd)

tier=smoke
interactive=0
distros=()

while [ $# -gt 0 ]; do
    case "$1" in
        --tier)
            tier=${2:?"--tier needs an argument"}
            shift 2
            ;;
        --shell)
            interactive=1
            shift
            ;;
        debian | arch)
            distros+=("$1")
            shift
            ;;
        all)
            distros+=(debian arch)
            shift
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

[ ${#distros[@]} -gt 0 ] || distros=(debian arch)

if [ "$interactive" = 1 ] && [ ${#distros[@]} -ne 1 ]; then
    echo "--shell requires exactly one distro" >&2
    exit 2
fi

# smoke runs against the tooling-baked stage; full must start from the
# fresh-system base stage so the real bootstrap path is exercised.
target=smoke
if [ "$tier" = full ]; then
    target=base
fi

# The smoke stage's `mise use nushell` (aqua backend) hits the GitHub API at
# build time — unauthenticated that rate-limits fast (60 req/h per IP; a few
# local rebuilds burn it). Feed MISE_GITHUB_TOKEN in as a build secret (never
# persisted in image layers). Locally, fall back to the gh CLI's token.
# The file always exists (possibly empty) so the Containerfile mount is stable.
if [ -z "${MISE_GITHUB_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
    MISE_GITHUB_TOKEN=$(gh auth token 2>/dev/null || true)
    export MISE_GITHUB_TOKEN
fi
secret_file=$(mktemp)
trap 'rm -f "$secret_file"' EXIT
printf '%s' "${MISE_GITHUB_TOKEN:-}" >"$secret_file"

for distro in "${distros[@]}"; do
    tag="dotfiles-test:${distro}-${target}"

    podman build --pull=newer --target "$target" \
        --secret "id=mise_github_token,src=$secret_file" \
        -f "$script_dir/Containerfile.$distro" -t "$tag" "$script_dir"

    run_args=(--rm --pull=never --volume "$repo:/src/dotfiles:ro,Z")
    # The full tier's mise install hits GitHub API rate limits unauthenticated.
    if [ -n "${MISE_GITHUB_TOKEN:-}" ]; then
        run_args+=(--env MISE_GITHUB_TOKEN)
    fi
    # chezmoi's source walk (data, execute-template) fails on unreadable dirs.
    # .claude/.cc-writes is mode 700 (Claude Code session write-tracking) and
    # unreadable under rootless podman's subuid mapping — shadow it with an
    # empty tmpfs. Absent in clean CI checkouts, hence the guard.
    # mode=0755: without it the tmpfs inherits the underlying dir's 700/uid,
    # which is exactly the unreadability being worked around.
    if [ -d "$repo/.claude/.cc-writes" ]; then
        run_args+=(--tmpfs /src/dotfiles/.claude/.cc-writes:mode=0755)
    fi

    if [ "$interactive" = 1 ]; then
        podman run "${run_args[@]}" -it "$tag" bash -l
    else
        echo "=== $distro / $tier tier ==="
        podman run "${run_args[@]}" "$tag" \
            bash /src/dotfiles/tests/podman/harness.sh --tier "$tier"
    fi
done
