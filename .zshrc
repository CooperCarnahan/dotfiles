# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
#ZSH_DISABLE_COMPFIX=true
#export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(
#    git
#    docker
#    docker-compose
#    ssh-agent
#    zsh-autosuggestions
#    zsh-syntax-highlighting
#    zsh-vim-mode
#    fzf
#    cp
#    colorize
#    fasd
#)

# ssh_identities_local file specifies which ssh keys to load. Else loads id_rsa only by default.
if [ -f $HOME/.ssh_identities.local ]; then
    ssh_identities=$(cat .ssh_identities.local)
    zstyle :omz:plugins:ssh-agent identities $ssh_identities 
fi

#source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
 else
  export EDITOR='nvim'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Placed elsewhere on different systems
#[[ -s "/usr/share/rvm/scripts/rvm" ]] && source "/usr/share/rvm/scripts/rvm"

# Init fasd script
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fasd --init auto)"


# # Set VIM keybindings for terminal
# set -o vi

bindkey '^R' history-incremental-search-backward

# # Add Old E-Macs-style commands
# bindkey -v 
# bindkey "^[[1;5C" forward-word
# bindkey "^[[1;5D" backward-word
# bindkey "^E" autosuggest-accept

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

# NVM
 export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Include externally defined alias'
source ~/.alias

# fix zsh autosuggestion highlight color issue
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

# Include zsh package install suggestions
if [ -z /etc/zsh_command_not_found ]; then 
    source /etc/zsh_command_not_found
fi

# Save command history
export HISTFILEZISE=1000000000
export HISTSIZE=1000000000
export HISTFILE=~/.zsh_history

setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Case-insensitive auto-suggestions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit snippet OMZP::git
zinit snippet OMZP::colorize
zinit snippet OMZP::ssh-agent

zinit for \
    light-mode  zsh-users/zsh-history-substring-search \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zsh-users/zsh-completions

zinit ice from"gh-r" as"program"
zinit light junegunn/fzf-bin
#zinit light Aloxaf/fzf-tab

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

#zinit lucid as=program pick="$ZPFX/bin/(fzf|fzf-tmux)" \
#    atclone="cp shell/completion.zsh _fzf_completion; \
#      cp bin/(fzf|fzf-tmux) $ZPFX/bin" \
#    make="PREFIX=$ZPFX install" for \
#        junegunn/fzf

zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

zinit wait lucid for \
    atinit"zicompinit; zicdreplay"   \
    zdharma/fast-syntax-highlighting \
    OMZP::colored-man-pages          

bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward


zinit ice depth=1; zinit light romkatv/powerlevel10k
