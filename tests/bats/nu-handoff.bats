#!/usr/bin/env bats
# The POSIX -> nushell handoff (~/.nu-handoff), sourced from ~/.bashrc and
# ~/.zshrc. The login shell stays bash/zsh so /etc/profile, profile.d and macOS
# path_helper all still run; this snippet is what turns the resulting
# interactive POSIX shell into nushell.
#
# Every guard here exists because getting it wrong breaks a real workflow, so
# each one gets a test. See the comments in dot_nu-handoff for the why.

load helpers/common

setup() {
    stub=$(make_nu_stub)
    rc=$(make_rc)
    # Resolved before the stub shadows it: the parent-process tests need to be
    # started by the real nushell binary, while the shell underneath still sees
    # the stub on PATH.
    real_nu=$(command -v nu || true)
}

@test "handoff snippet is installed" {
    [ -f "$(handoff_snippet)" ]
}

@test "interactive shell hands off to nushell" {
    run env PATH="$stub:$PATH" bash --rcfile "$rc" -i </dev/null
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" == *HANDOFF_FIRED* ]]
}

@test "non-interactive shell does not hand off" {
    # A script file, deliberately not `bash -c`: -c would also trip the
    # command-string guard, so this would pass even with the interactive check
    # deleted. Running a file isolates the interactive check on its own.
    printf '. "%s"\necho SURVIVED\n' "$(handoff_snippet)" \
        >"$BATS_TEST_TMPDIR/script.sh"
    run env PATH="$stub:$PATH" bash "$BATS_TEST_TMPDIR/script.sh"
    [[ "$output" == *SURVIVED* ]]
    [[ "$output" != *HANDOFF_FIRED* ]]
}

@test "interactive shell running a -c command does not hand off" {
    # `$SHELL -ic 'cmd'` is interactive AND has a command string. exec'ing nu
    # here would silently discard the command.
    run env PATH="$stub:$PATH" bash --rcfile "$rc" -i -c 'echo SURVIVED' </dev/null
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" == *SURVIVED* ]]
    [[ "$output" != *HANDOFF_FIRED* ]]
}

@test "shell spawned from nushell does not hand off" {
    # Typing `bash` inside nu must give you bash. Uses the real nu binary
    # because the guard reads the parent's process name.
    [ -n "$real_nu" ] || skip "nushell not installed"
    # `exec`, so the shell nu spawns *becomes* bash and bash's direct parent is
    # the nu process itself.
    printf '#!/bin/sh\nexec bash --rcfile "%s" -i </dev/null\n' "$rc" \
        >"$BATS_TEST_TMPDIR/spawn"
    chmod +x "$BATS_TEST_TMPDIR/spawn"

    run env PATH="$stub:$PATH" "$real_nu" -c "^$BATS_TEST_TMPDIR/spawn"
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" != *HANDOFF_FIRED* ]]
}

@test "multiplexer panes started from nushell still hand off" {
    # The regression an exported sentinel variable would cause: tmux/zellij
    # inherit the environment of the nu that launched them, so a pane's shell
    # must still hand off even though nu is an ancestor. Only a *direct* nu
    # parent suppresses it, which a stub named `tmux` stands in for here.
    [ -n "$real_nu" ] || skip "nushell not installed"
    # No `exec` here: the intermediate stays alive, so bash's parent is that
    # process and nu is only a grandparent — the shape tmux and zellij create.
    printf '#!/bin/sh\nbash --rcfile "%s" -i </dev/null\n' "$rc" \
        >"$BATS_TEST_TMPDIR/tmux"
    chmod +x "$BATS_TEST_TMPDIR/tmux"

    run env PATH="$stub:$PATH" "$real_nu" -c "^$BATS_TEST_TMPDIR/tmux"
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" == *HANDOFF_FIRED* ]]
}

@test "finds nushell via mise shims when PATH lacks it" {
    # Debian, where nushell comes from mise rather than a system package: the
    # shims dir only reaches PATH via `mise activate`, which happens after the
    # handoff. So the handoff has to find the toolchain itself. (macOS is the
    # same problem with a different directory — /opt/homebrew/bin, which
    # path_helper does not include — handled by the same probe loop.)
    PATH=/usr/bin:/bin command -v nu >/dev/null && skip "nu present in /usr/bin"
    fake=$BATS_TEST_TMPDIR/home
    mkdir -p "$fake/.local/share/mise/shims"
    printf '#!/bin/sh\necho HANDOFF_FIRED\n' >"$fake/.local/share/mise/shims/nu"
    chmod +x "$fake/.local/share/mise/shims/nu"

    run env HOME="$fake" PATH=/usr/bin:/bin bash --rcfile "$rc" -i </dev/null
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" == *HANDOFF_FIRED* ]]
}

@test "shell survives when nushell is not installed" {
    # A box whose toolchain is not provisioned yet must still get a usable
    # shell rather than a terminal that closes instantly. HOME is faked so the
    # real machine's mise shims can't satisfy the lookup above.
    PATH=/usr/bin:/bin command -v nu >/dev/null && skip "nu present in /usr/bin"
    fake=$BATS_TEST_TMPDIR/home
    mkdir -p "$fake"

    run env HOME="$fake" PATH=/usr/bin:/bin bash --rcfile "$rc" -i </dev/null
    [ "$status" -eq 0 ]
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" != *HANDOFF_FIRED* ]]
}

@test "interactive zsh hands off to nushell" {
    command -v zsh >/dev/null || skip "zsh not installed"
    cp "$rc" "$BATS_TEST_TMPDIR/.zshrc"
    run env PATH="$stub:$PATH" ZDOTDIR="$BATS_TEST_TMPDIR" zsh -i </dev/null
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" == *HANDOFF_FIRED* ]]
}

@test "interactive zsh running a -c command does not hand off" {
    command -v zsh >/dev/null || skip "zsh not installed"
    cp "$rc" "$BATS_TEST_TMPDIR/.zshrc"
    run env PATH="$stub:$PATH" ZDOTDIR="$BATS_TEST_TMPDIR" zsh -i -c 'echo SURVIVED' </dev/null
    [[ "$output" == *RC_SOURCED* ]]
    [[ "$output" == *SURVIVED* ]]
    [[ "$output" != *HANDOFF_FIRED* ]]
}
