#!/usr/bin/env bats
# Core assertions — run in BOTH tiers (harness.sh runs this file always, and
# additionally full.bats when --tier full).

load helpers/common

@test "osid renders the real distro identity" {
    run chez execute-template '{{ .osid }}'
    [ "$status" -eq 0 ]
    [ "$output" = "linux-$(distro_id)" ]
}

@test "headless/work/pushoverUrl render as expected" {
    run chez execute-template '{{ .headless }}/{{ .work }}/{{ .pushoverUrl }}'
    [ "$status" -eq 0 ]
    [ "$output" = "true/false/" ]
}

@test "nushell config files installed" {
    [ -f "$HOME/.config/nushell/env.nu" ]
    [ -f "$HOME/.config/nushell/config.nu" ]
}

@test "nushell starts as a login shell" {
    run nu -l -c 'print loaded'
    [ "$status" -eq 0 ]
}

@test "vendor autoload contains 00-mise.nu" {
    # shellcheck disable=SC2016  # $nu.data-dir is nushell syntax, not shell
    autoload_dir=$(nu -l -c '$nu.data-dir | path join "vendor/autoload"')
    [ -d "$autoload_dir" ]
    [ -f "$autoload_dir/00-mise.nu" ]
}

@test "mise config installed and parses" {
    [ -f "$HOME/.config/mise/config.toml" ]
    run mise config ls
    [ "$status" -eq 0 ]
}

@test "gitconfig renders with a user name" {
    run git config --file "$HOME/.gitconfig" user.name
    [ "$status" -eq 0 ]
    [ -n "$output" ]
}

@test "bashrc is syntactically valid" {
    [ -f "$HOME/.bashrc" ]
    run bash -n "$HOME/.bashrc"
    [ "$status" -eq 0 ]
}

@test "headless ignore gates hold (no GUI configs deployed)" {
    [ ! -e "$HOME/.config/hypr" ]
    [ ! -e "$HOME/.config/ghostty" ]
    [ ! -e "$HOME/.config/noctalia" ]
    [ ! -e "$HOME/.config/wlogout" ]
    [ ! -e "$HOME/.config/hyprdynamicmonitors" ]
}

@test "repo infrastructure not deployed to HOME" {
    [ ! -e "$HOME/tests" ]
    [ ! -e "$HOME/.github" ]
}

@test "claude settings.json native modifier seeds managed keys" {
    [ -f "$HOME/.claude/settings.json" ]
    run jq -e '.editorMode == "vim" and .model == "opus" and (.permissions.allow | length) > 0' \
        "$HOME/.claude/settings.json"
    [ "$status" -eq 0 ]
}

@test "claude modifier preserves runtime state and exact bytes on semantic no-op" {
    settings="$HOME/.claude/settings.json"
    tmp=$(mktemp)

    jq '.runtimeTest = {keep: true} | .permissions = {allow: ["sentinel"]}' \
        "$settings" > "$tmp"
    mv "$tmp" "$settings"
    before=$(sha256sum "$settings" | cut -d' ' -f1)

    chez apply --force --refresh-externals=never --exclude scripts
    after=$(sha256sum "$settings" | cut -d' ' -f1)
    [ "$after" = "$before" ]
    jq -e '.runtimeTest.keep == true and .permissions.allow == ["sentinel"]' "$settings"

    jq '.editorMode = "emacs"' "$settings" > "$tmp"
    mv "$tmp" "$settings"
    chez apply --force --refresh-externals=never --exclude scripts
    jq -e '.editorMode == "vim" and .runtimeTest.keep == true and .permissions.allow == ["sentinel"]' \
        "$settings"
}

@test "second apply is idempotent" {
    # --exclude scripts in both tiers: full's scripts already ran once, and
    # file-state idempotency is the contract being tested.
    chez apply --force --refresh-externals=never --exclude scripts
    # stdout only — mise shims emit WARNs on stderr for not-yet-installed tools.
    diff_output=$(chez diff --exclude scripts 2>/dev/null)
    [ -z "$diff_output" ]
}
