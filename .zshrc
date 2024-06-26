###################################
#           CONFIGS               #
###################################

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
 DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
 DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
 DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Automatically do a pushd of each directory you change to
setopt AUTO_PUSHD

# Save command history
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zsh_history

setopt HIST_FIND_NO_DUPS
# Shares history between terminals instantlye
setopt SHARE_HISTORY

# Disable beeping sound on in terminal
unsetopt BEEP

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Starts ssh-keychain which clobbers all agents into single entity
# Clear all existing keys so hackers will have to reenter password
if command -v keychain &> /dev/null; then
  keychain --clear --quiet
   [ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
   [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
   . $HOME/.keychain/$HOSTNAME-sh
fi

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
#  else
export EDITOR='nvim'
# fi

export PAGER='less -R'
export BAT_PAGER='less -R'

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
 # Placed elsewhere on different systems
[[ -s "/usr/share/rvm/scripts/rvm" ]] && source "/usr/share/rvm/scripts/rvm"

###################################
#       ZSH VIM MODE KEYBINDS     #
###################################

# # Set VIM keybindings for terminal
# set -o vi

bindkey "^N" down-line-or-search
bindkey "^P" up-line-or-search

bindkey '^R' history-incremental-search-backward

# # Add Old E-Macs-style commands
# bindkey -v 
# bindkey "^[[1;5C" forward-word
# bindkey "^[[1;5D" backward-word
bindkey "^E" autosuggest-accept

# # Better searching in command mode
 bindkey -M vicmd '?' history-substring-search-up
 bindkey -M vicmd '/' history-substring-search-down

# # Beginning search with arrow keys
 #bindkey "^[OA" up-line-or-beginning-search
 #bindkey "^[OB" down-line-or-beginning-search
 #bindkey -M vicmd "k" up-line-or-beginning-search
 #bindkey -M vicmd "j" down-line-or-beginning-search

# #Set jk to send 'escape' key during insert mode 
 bindkey -M viins 'jk' vi-cmd-mode

# Remove alt-h,j,k,l keybinds so tmux can use them
 bindkey -s "^[h" ""
 bindkey -s "^[j" ""
 bindkey -s "^[k" ""
 bindkey -s "^[l" ""

# Set cursor to underline in insert mode
 MODE_CURSOR_VIINS="#eceff1 blinking underline"

# Use ripgrep for fzf searches
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if ! command -v bat &> /dev/null; then
    echo "'bat' not installed. Using default 'cat'"
else
    export BAT_THEME=TwoDark
fi

###################################
#           ZINIT                 #
###################################
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit ice wait lucid
zinit snippet OMZP::git
zinit ice wait lucid
# zinit snippet OMZP::colorize

zinit light Aloxaf/fzf-tab
# Autosuggestion stuff
zinit lucid for \
    light-mode  zsh-users/zsh-history-substring-search \
    light-mode  zsh-users/zsh-autosuggestions \
    # light-mode  zsh-users/zsh-completions
    
# Case-insensitive auto-suggestions
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward

# fzf stuff
zinit ice from"gh-r" as"program"
zinit ice wait lucid 0
# set list-colors to enable filename colorizing
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# git stuff
zinit load wfxr/forgit

# Syntax highlighting
zinit wait lucid for \
    atinit"zicompinit; zicdreplay"   \
    zdharma-continuum/fast-syntax-highlighting \

###################################
#           THEME                 #
###################################

# use starship prompt
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
eval "$(starship init zsh)"

###################################
#          ALIAS                  #
###################################
if [[ -f $HOME/.alias ]]; then
  source $HOME/.alias
fi

###################################
#          FUNCTIONS              #
###################################
if [[ -f $HOME/.functions ]]; then
  source $HOME/.functions
fi

###################################
#          LOCAL ZSHRC            #
###################################
if [[ -f $HOME/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

###################################
#          PATH                   #
###################################

if [[ -d /usr/local/go ]]; then
  export PATH=$PATH:/usr/local/go/bin
fi

if [[ -d $HOME/go ]]; then
  export PATH=$PATH:$HOME/go/bin
fi

if [[ -d $HOME/.scripts ]]; then
  export PATH=$PATH:$HOME/.scripts
fi

if [[ -d $HOME/.local/bin ]]; then
  export PATH=$PATH:$HOME/.local/bin
fi

###################################
#          mcfly                  #
###################################
if command -v mcfly &> /dev/null; then
  eval "$(mcfly init zsh)"
fi

###################################
#          rpick                  #
###################################
export RPICK_CONFIG=~/.config/rpick.yml

export NVM_DIR="$HOME/.nvm"
 export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

###################################
#          zoxide                 #
###################################
eval "$(zoxide init zsh)"

###################################
#          vcpkg                  #
###################################
if [[ -d $HOME/.vcpkg/ ]]; then
  export CMAKE_TOOLCHAIN_FILE="$HOME/.vcpkg/scripts/buildsystems/vcpkg.cmake"
  elif [[ -d $HOME/vcpkg/ ]]; then
  export CMAKE_TOOLCHAIN_FILE="$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake"
fi

eval "$(ntfy shell-integration)"
export AUTO_NTFY_DONE_IGNORE="nvim vim tmux zellij cat bat v lg ylg lazygit ssh"

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[3;37mCompleting %d\e[m'
source <(carapace _carapace)
