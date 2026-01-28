# env.nu
# Installed by:
# version = "0.109.1"

$env.YAZI_CONFIG_HOME = "~/.config/yazi"
$env.EDITOR = "nvim"
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
$env.FZF_DEFAULT_OPTS = '--reverse'
$env.config.edit_mode = 'vi'

# pager
$env.MANPAGER = "sh -c 'awk \"{ gsub(/\\x1B\\[[0-9;]*m/, \\\"\\\", \$0); gsub(/.\\x08/, \\\"\\\", \$0); print }\" | bat -p -lman'"

# misc. path stuff
{{- if ne .chezmoi.os "windows" }}
$env.path ++= ["~/.local/bin"]

# rust
$env.path ++= ["~/.cargo/bin"]

# golang
$env.path ++= ["~/go/bin"]
$env.path ++= ["/usr/local/go/bin"]
{{- end }}

# mise (must activate first to get correct PATH for tools)
let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save --force $mise_path

# Tool integrations via vendor autoload (after mise activation)
let autoload_dir = $nu.data-dir | path join "vendor/autoload"
mkdir $autoload_dir

# carapace completions
if (which carapace | is-not-empty) {
  $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
  carapace _carapace nushell | save --force ($autoload_dir | path join "carapace.nu")
}

# zoxide smart cd
if (which zoxide | is-not-empty) {
  zoxide init nushell | save --force ($autoload_dir | path join "zoxide.nu")
}

# atuin shell history
if (which atuin | is-not-empty) {
  atuin init nu | save --force ($autoload_dir | path join "atuin.nu")
}

# starship prompt
if (which starship | is-not-empty) {
  starship init nu | save --force ($autoload_dir | path join "starship.nu")
}
