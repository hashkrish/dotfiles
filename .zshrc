# ============================================
# HISTORY CONFIGURATION
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY

# ============================================
# TERMINAL AND DISPLAY SETTINGS
# ============================================
_TERM=$TERM
TERM=xterm-256color

# ============================================
# PATH CONFIGURATION
# ============================================
# Local binaries
export PATH=~/.local/bin:$PATH

# Go binaries
if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# pnpm
export PNPM_HOME="/home/krishnan/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# envman PATH
[ -f ~/.config/envman/PATH.env ] && source ~/.config/envman/PATH.env

# Zsh completions
fpath=(/home/krishnan/.zsh-completions $fpath)

# ============================================
# ENVIRONMENT VARIABLES
# ============================================
# Locale
export MANPATH="/usr/local/man:$MANPATH"

# Theme (light/dark), toggled by ~/.local/bin/toggle-theme
TERMINAL_SCHEME=$(cat "${XDG_RUNTIME_DIR:-/tmp}/theme-mode" 2>/dev/null || echo "dark")

if [ "$TERMINAL_SCHEME" = "light" ]; then
    export BAT_THEME="OneHalfLight"
    export STARSHIP_CONFIG="$HOME/.config/starship.light.toml"
    # Default LS_COLORS uses ln=01;36 (bold ANSI cyan) for symlinks, which is
    # too light to read on a white background. Override with a darker teal.
    eval "$(dircolors -b)"
    export LS_COLORS="${LS_COLORS}:ln=38;2;14;116;144"
else
    export BAT_THEME="OneHalfDark"
    export STARSHIP_CONFIG="$HOME/.config/starship.dark.toml"
fi
export MANPAGER=less

# Ruby gems
export GEM_HOME="$HOME/gems"

# Ollama models
export OLLAMA_MODELS="$HOME/.local/share/ollama/models"

# Erlang history
export ERL_AFLAGS="-kernel shell_history enabled"

# ============================================
# PLUGIN MANAGER (ZPLUG)
# ============================================
export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/git", from:oh-my-zsh

zplug load

# ============================================
# TOOL INITIALIZATIONS
# ============================================
# NVM
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# Pyenv
eval "$(pyenv init - zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# Google Cloud SDK
[ -f "$HOME/sources/google-cloud-sdk/path.zsh.inc" ] &&
    . "$HOME/sources/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/sources/google-cloud-sdk/completion.zsh.inc" ] &&
    . "$HOME/sources/google-cloud-sdk/completion.zsh.inc"

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Starship prompt
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  eval "$(starship init zsh)"
fi

# UV completion
eval $(uv generate-shell-completion zsh)

# Atuin shell history
eval "$(atuin init zsh)"

# ============================================
# CUSTOM FUNCTIONS
# ============================================
# User-defined functions
source ~/.usr_fn

# Fuzzy find directory and open in neovim
nvim-fzf() {
    selection="$(zoxide query -i)"
    if [ -n "$selection" ]; then
        nvim "$selection"
    fi
}
zle -N nvim-fzf

# ============================================
# KEY BINDINGS
# ============================================
# Navigation
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^F" forward-char
bindkey "^B" backward-char
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# Editing
bindkey "^U" backward-kill-line
bindkey "^K" kill-line
bindkey "^W" backward-kill-word
bindkey "^D" delete-char
bindkey "^H" backward-delete-char
bindkey "^Y" yank
bindkey "^T" transpose-chars

# History search
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# Command line operations
bindkey "^L" clear-screen
bindkey "^J" accept-line
bindkey "^M" accept-line
bindkey "^C" send-break
bindkey "^Z" push-line

# Extended commands (^X prefix)
bindkey "^X^X" exchange-point-and-mark
bindkey "^X^A" accept-and-hold
bindkey "^X^Y" yank-pop
bindkey "^X^U" undo
bindkey "^X^E" edit-command-line
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

# Custom functions
bindkey '^[e' nvim-fzf
bindkey -s '^o' 'zi\n'

source <(atuin init zsh)
source <(helm completion zsh)
source <(kind completion zsh)
source <(kubectl completion zsh)
source <(podman completion zsh)

# ============================================
# ALIASES
# ============================================
source ~/.bash_aliases
source ~/.zsh_aliases

alias docker=podman

# ============================================
# CONDITIONAL STARTUP
# ============================================
# Source environment variables
[ -f ~/.env.sh ] && source ~/.env.sh

# Auto-start Sway on linux console
if [ $_TERM = "linux" ]; then
    setfont ter-h24n
    sway
    unset _TERM
fi

# Emacs-specific configuration
if [ -n "$INSIDE_EMACS" ]; then
    set -o emacs
    export EDITOR=
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


autoload -U edit-command-line
zle -N edit-command-line


autoload -Uz compinit
compinit


# Added by sonarqube-cli installer
export PATH="$HOME/.local/share/sonarqube-cli/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section
