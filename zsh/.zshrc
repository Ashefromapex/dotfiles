
. "$HOME/.local/bin/env"

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/Users/luca/.lmstudio/bin"
alias python=/usr/bin/python3
alias python=/usr/bin/python3
alias python=/Applications/Python 3.13
alias python=/usr/bin/python3

# personal
source /Users/luca/personal/scripts/webui-control.sh

#path shit
export PATH=$PATH:~/.cargo/bin/

alias smassh="~/smassh"

alias vim="nvim"
alias svim="sudo nvim"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/luca/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/luca/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/luca/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/luca/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# brew installation activation 
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# FZF
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#a9b665"

# fzf previews 
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {} | head -200'"

#z oxdide
eval "$(zoxide init zsh)"

#eza 
alias ls="eza --long --color=always --icons=always --no-user "
alias lsa="eza --long --color=always --icons=always --no-user --all "
# --no-permissions wenn man die weghaben will aber geht ig

# z init package manager 

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions 

# load completions
autoload -U compinit && compinit 


# history + keybinds 
# Keybindings
# bindkey -e dont know that this does 
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export OPENAI_API_KEY='123'

eval "$(starship init zsh)"
