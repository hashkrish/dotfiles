# User configuration

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8

export MANPATH="/usr/local/man:$MANPATH"

# Bat configuration
export BAT_THEME="OneHalfDark"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER=less

# NVM 
source /usr/share/nvm/init-nvm.sh

# Perl
export GEM_HOME="$HOME/gems"

# Extra User defined functions
source ~/.usr_fn

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

_TERM=$TERM

TERM=xterm-256color

export PATH=~/.local/bin:$PATH

source ~/.bash_aliases

# Enable Zoxide
eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/sources/google-cloud-sdk/path.zsh.inc" ] &&
	. "$HOME/sources/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/sources/google-cloud-sdk/completion.zsh.inc" ] &&
	. "$HOME/sources/google-cloud-sdk/completion.zsh.inc"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pnpm
export PNPM_HOME="/home/krishnan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

source ~/.config/envman/PATH.env

fpath=(/home/krishnan/.zsh-completions $fpath)

if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

nvim-fzf() {
    selection="$(zoxide query -i)"
    if [ -n "$selection" ]; then
        nvim "$selection"
    fi
}

zle -N nvim-fzf

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export OLLAMA_MODELS="$HOME/.local/share/ollama/models"

# ZPlug
export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

# Make sure to use double quotes
zplug "zsh-users/zsh-history-substring-search"

# Supports oh-my-zsh plugins and the like
zplug "plugins/git",   from:oh-my-zsh

zplug load

# source /home/krishnan/sources/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /home/krishnan/.zsh_aliases

bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^F" forward-char
bindkey "^B" backward-char
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^U" backward-kill-line
bindkey "^K" kill-line
bindkey "^W" backward-kill-word
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^D" delete-char
bindkey "^H" backward-delete-char
bindkey "^L" clear-screen
bindkey "^J" accept-line
bindkey "^M" accept-line
bindkey "^C" send-break
bindkey "^Z" push-line
bindkey "^Y" yank
bindkey "^T" transpose-chars
bindkey "^X^X" exchange-point-and-mark
bindkey "^X^A" accept-and-hold
bindkey "^X^Y" yank-pop
bindkey "^X^U" undo
bindkey "^X^V" edit-command-line
bindkey "^X^E" edit-and-execute-command
bindkey "^X^F" expand-cmd-path
bindkey "^X^G" list-expand
bindkey "^X^H" run-help
bindkey "^X^I" expand-or-complete
bindkey "^X^J" list-jobs
bindkey "^X^K" kill-buffer
bindkey "^X^N" list-names
bindkey "^X^O" list-choices
bindkey "^X^P" list-parameters
bindkey "^X^Q" push-input
bindkey "^X^R" read-command
bindkey "^X^S" list-commands
bindkey "^X^T" transpose-words
bindkey "^X^U" up-history
bindkey "^X^V" complete-command
bindkey "^X^W" expand-word

bindkey '^[e' nvim-fzf

eval "$(starship init zsh)"
eval $(uv generate-shell-completion zsh)

source /home/krishnan/.zsh_aliases

export ERL_AFLAGS="-kernel shell_history enabled"

source ~/.env.sh
if [ $_TERM = "linux" ]; then
    setfont ter-h24n
    # echo "Do you want to start Hyprland?"
    # read choice
    # if [ "$choice" = y ]; then
    #     Hyprland
    # fi
    sway
    unset _TERM
fi
eval "$(atuin init zsh)"

if [ -n "$INSIDE_EMACS" ]; then
  set -o emacs
  export EDITOR=
fi
