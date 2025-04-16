# env.nu
#
# Installed by:
# version = "0.103.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.EDITOR = "nvim"

{{- if contains (lower .chezmoi.hostname) "cooper" }}
$env.PUSHOVER_APP_TOKEN = "{{- (onepasswordDetailsFields "m3fndragiw4abz2kk3l5zjjj7i").credential.value }}"
$env.PUSHOVER_USER_KEY = "{{- (onepasswordDetailsFields "m3fndragiw4abz2kk3l5zjjj7i").username.value }}"
{{- end}}

# carapace
if (which carapace | is-not-empty) {
  $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
  mkdir ~/.cache/carapace
  carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
}

# starship
if (which starship | is-not-empty) {
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
}

# zoxide
if (which zoxide | is-not-empty) { 
  zoxide init nushell | save -f ~/.zoxide.nu
}

# atuin
if (which atuin | is-not-empty) {
  mkdir ~/.local/share/atuin/
  atuin init nu | save -f ~/.local/share/atuin/init.nu
}
