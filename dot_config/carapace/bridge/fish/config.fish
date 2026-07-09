# fish 4.8 made __fish_config_dir read-only, so carapace's fish bridge can no
# longer point fish at this sandbox dir ("set __fish_config_dir ..." errors and
# "$__fish_data_dir/config.fish" resolves to /config.fish under --no-config).
# Result: fish_complete_path never includes any completion dirs and every
# bridged command falls back to file completion. This file IS still sourced by
# the bridge (via literal path), so restore the lookup paths here.
set -p fish_complete_path $HOME/.config/carapace/bridge/fish/completions $HOME/.config/fish/completions
