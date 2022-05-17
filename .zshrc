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
keychain --clear --quiet
source $HOME/.keychain/$(uname -n)-sh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
#  else
export EDITOR='nvim'
# fi

export PAGER='less -r'
export BAT_PAGER='less -r'

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
 # Placed elsewhere on different systems
[[ -s "/usr/share/rvm/scripts/rvm" ]] && source "/usr/share/rvm/scripts/rvm"

# Init fasd script
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fasd --init auto)"

###################################
#       ZSH VIM MODE KEYBINDS     #
###################################

# # Set VIM keybindings for terminal
# set -o vi

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

# #Set jj to send 'escape' key during insert mode 
 bindkey -M viins 'jj' vi-cmd-mode

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
    if command -v delta &> /dev/null; then
      export DELTA_PAGER=bat
    fi
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
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit ice wait lucid
zinit snippet OMZP::git
zinit ice wait lucid
# zinit snippet OMZP::colorize

# Autosuggestion stuff
zinit lucid for \
    light-mode  zsh-users/zsh-history-substring-search \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zsh-users/zsh-completions
    
# Case-insensitive auto-suggestions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward

# fzf stuff
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf-bin
zinit ice wait lucid 0
zinit light Aloxaf/fzf-tab
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Include zsh package install suggestions
if [ -z /etc/zsh_command_not_found ]; then 
    source /etc/zsh_command_not_found
fi

zinit ice depth=1; zinit light romkatv/powerlevel10k

###################################
#          ALIAS                  #
###################################
source ~/.alias

###################################
#          FUNCTIONS              #
###################################
source ~/.functions

###################################
#          LOCAL ZSHRC            #
###################################
if [[ -f ~/.zshrc.local ]]; then
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

source $HOME/.config/broot/launcher/bash/br

###################################
#          rpick                  #
###################################

export RPICK_CONFIG=~/.config/rpick.yml
