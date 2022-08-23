# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*)
    set -o vi
    ;;
  *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *) ;;

esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#  ---------------- USER CONF ----------------
export BAT_THEME="OneHalfDark"
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export DENO_INSTALL="/home/krishnan/.deno"
## Exports
export LANG=en_US.UTF-8
export NVM_DIR="$HOME/.nvm"
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"


# ALIAS
alias update="sudo apt-get update"
alias upgrade="sudo apt-get upgrade"
alias py3="python3"
alias ipy3="ipython3"
alias sqlite="sqlite3"
alias svim="vim -u ~/.SpaceVim/vimrc"
alias bathelp='batcat --plain --language=man'
alias first='head -1'
alias lfirst='tail -1'
alias rm="trash-put"
alias pdb="python3 -m pdb"
alias tmuxw='tmux attach -t workflow-dev'
alias tmuxs='tmux attach -t seek-dev'
alias tmuxg='tmux attach -t general'
alias tmuxc='tmux attach -t config'

alias e="emacsclient"
alias m="man"
alias b="batcat -n"

alias vfzf='v $(fzf)'
# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] &&
  . /usr/share/bash-completion/bash_completion

# PS
PS1='\n${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\n❯ '

#LS_COLORS='rs=0:di=07;34;107:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
#export LS_COLORS

#if command -v tmux &> /dev/null && [ -n "$PS1"  ] && [[ ! "$TERM" =~ screen  ]] && [[ ! "$TERM" =~ tmux  ]] && [ -z "$TMUX"  ]; then
#    exec tmux
#fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
. "$HOME/.cargo/env"

## Sourcing
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "/home/krishnan/.ghcup/env" ] && source "/home/krishnan/.ghcup/env" # ghcup-env
source ~/.local/share/blesh/ble.sh
# Load Angular CLI autocompletion.
source <(ng completion script)
source ~/sources/z/z.sh

## Custom functions
mkdircd() {
  mkdir -p "$@" && cd "$1"
}

tmp() {
  mkdircd ~/tmp/$RANDOM
}

touchmod() {
  touch "$2"
  chmod $1 "$2"
}

update_ssh_config() {
  cat ~/.ssh/config
  read -n 1 -p 'It will overwrite config file, do you want to proceed [y/n]?' res
  pat='y|Y'
  ! [[ $res =~ $pat ]] && exit

  gcloud compute instances list |
    sed -n '1! p' |
    awk '{print $1,$5}' |
    while read name ip; do
      echo "Host $name
  HostName $ip
  User ubuntu
  Port 22
"
    done > ~/.ssh/config
}

# One character alias
h() {
  echo "$@" --help
  "$@ --help" 2>&1 | bathelp
}

o() {
  case "$(file "$1" --mime-type)" in
    *text*)
      v "$1"
      ;;
    *pdf)
      evince "$1"
      ;;
    video*)
      mpv "$1"
      ;;
    *)
      xdg-open "$1"
      ;;
  esac
}

v() {
  if [ $# -eq 0 ]; then
    "$EDITOR" -c 'Telescope oldfiles'
  else
    "$EDITOR" $@
  fi
}

install_missing_package() {
  if [[ $? == 127 ]]; then
    PACKAGE_NAME="$(history 2 | head -1 | awk '{print $2}')"
    read -n 1 \
      -p "Do you want to install $PACKAGE_NAME [y/n]?" \
      should_install
    echo
    if [[ $should_install == y || $should_install == Y ]]; then
      sudo apt install "$PACKAGE_NAME" -y
    fi
  fi
}

get-key() {
  [[ $# == 0 ]] && echo Requires username
  case $1 in
    hashkrish)
      cat ~/.hk_ghk | xsel -ib
      ;;
    krishnan314)
      cat ~/.k3_ghk | xsel -ib
      ;;
    *)
      echo No Key Found
      ;;
  esac
}

## Startup text and PS
#eval "$(starship init bash)"
figlet ${SHELL##*\/} | lolcat

## ble.sh
# ble.sh theme
ble-face auto_complete=fg=244

# ble.sh sabbrev
ble-sabbrev B='| bat'
ble-sabbrev L='| less'
ble-sabbrev G='| grep'
ble-sabbrev H='--help'
ble-sabbrev xc='| xsel -ib'
ble-sabbrev xo='xsel -ob'

# ble.sh sabbrev

#ble.sh key-bindings
ble-bind -m 'vi_imap' -f 'M-.' 'insert-last-argument'
ble-bind -m 'auto_complete' -f 'C-I' 'auto_complete/insert-on-end'
ble-bind -m 'auto_complete' -f 'M-i' 'auto_complete/insert-on-end'
ble-bind -m 'vi_imap' -f 'M-f' 'forward-char'
ble-bind -m 'vi_imap' -c 'C-M-r' "source ~/.bashrc"
ble-bind -m 'vi_nmap' -c 'C-M-r' "source ~/.bashrc"
ble-bind -m 'vi_imap' -f 'C-b' '@nomarked backward-cword'
ble-bind -m 'vi_imap' -f 'C-S-b' '@marked backward-cword'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/krishnan/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/krishnan/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/krishnan/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/krishnan/Downloads/google-cloud-sdk/completion.bash.inc'; fi
