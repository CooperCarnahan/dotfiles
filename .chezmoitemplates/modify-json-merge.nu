#!/usr/bin/env nu
# Shared body for chezmoi modify_ scripts over app-owned JSON settings files.
# Rendered via includeTemplate with a dict carrying "desired" — the JSON block
# of keys chezmoi enforces, kept as a sibling .chezmoitemplates/<name>.json
# and read with include. (Can't show the literal call here: template syntax
# in this comment would be executed.)
#
# The app owns the live file (rewrites it, adds runtime keys, migrates its
# schema); chezmoi owns only the keys in the desired block. Deep-merging
# desired over the live stdin keeps the app's keys and key order, so
# `chezmoi diff` stays quiet and apply never prompts about external edits.
# Same pattern as dot_claude/modify_settings.json.nu.tmpl — see its header.
#
# Body lives in main: nu rejects `$in` at script top level; with --stdin
# (set in [interpreters.nu]) main receives the live file as pipeline input.
def main [] {

let raw = ($in | default "" | str trim)

let live = (if ($raw | is-empty) { "{}" } else { $raw }) | from json

let desired = r#'
{{ .desired }}
'# | from json

# --strategy overwrite replaces arrays wholesale (default `table` would
# element-merge lists and corrupt e.g. profile lists).
$live | merge deep --strategy overwrite $desired | to json --indent 2

}
