#!/usr/bin/env bats
# Bootstrap-specific assertions — full tier only. Verifies `mise bootstrap
# packages apply` + the AUR script materialized a working system.

load helpers/common

@test "bootstrap packages converged" {
    run mise bootstrap packages status --missing
    [ "$status" -eq 0 ]
}

@test "mise toolchain materialized" {
    run mise ls --installed
    [ "$status" -eq 0 ]
    [[ "$output" == *nushell* ]]
    [[ "$output" == *uv* ]]
    [[ "$output" == *node* ]]
    command -v nu
    command -v uv
}

@test "paru installed (arch only)" {
    [ "$(distro_id)" = "arch" ] || skip "arch only"
    command -v paru
}

@test "sample pacman package installed (arch only)" {
    [ "$(distro_id)" = "arch" ] || skip "arch only"
    pacman -Qi tree
}

@test "system build packages installed (debian only)" {
    [ "$(distro_id)" = "debian" ] || skip "debian only"
    dpkg -s build-essential
}

@test "apprise installed via mise pipx backend" {
    command -v apprise
}

@test "claude setup skipped under DOTFILES_TEST" {
    # The DOTFILES_TEST guard should have short-circuited the plugin
    # marketplace registration entirely.
    [ ! -d "$HOME/.claude/plugins/marketplaces" ]
}
