# env.nu
# Installed by:
# version = "0.103.0"

$env.YAZI_CONFIG_HOME = "~/.config/yazi"
$env.EDITOR = "nvim"
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
$env.FZF_DEFAULT_OPTS = '--reverse'
$env.config.edit_mode = 'vi'

# pager
{{- if or (eq .chezmoi.os "linux") (eq .chezmoi.os "darwin") }}
$env.MANPAGER = "sh -c 'awk \"{ gsub(/\\x1B\\[[0-9;]*m/, \\\"\\\", \$0); gsub(/.\\x08/, \\\"\\\", \$0); print }\" | bat -p -lman'"
{{- end }}

# misc. path stuff
$env.path ++= ["~/.local/bin"]

# rust
$env.path ++= ["~/.cargo/bin"]

# golang
$env.path ++= ["~/go/bin"]
{{- if eq .chezmoi.os "linux" }}
$env.path ++= ["/usr/local/go/bin"]
{{- else if eq .chezmoi.os "darwin" }}
$env.path ++= ["/opt/homebrew/bin"]
{{- end }}

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

# zoxide
if (which zoxide | is-not-empty) { 
  zoxide init nushell | save -f ~/.zoxide.nu
}

# atuin
if (which atuin | is-not-empty) {
  mkdir ~/.local/share/atuin/
  atuin init nu | save -f ~/.local/share/atuin/init.nu
}

# mise
let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
