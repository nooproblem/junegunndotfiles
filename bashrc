# .bashrc for OS X and Ubuntu
# ====================================================================
# - https://github.com/junegunn/dotfiles
# - junegunn.c@gmail.com

# System default
# --------------------------------------------------------------------

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

BASE=$(dirname $(readlink $BASH_SOURCE))

# Options
# --------------------------------------------------------------------

### Append to the history file
shopt -s histappend

### Check the window size after each command ($LINES, $COLUMNS)
shopt -s checkwinsize

### Better-looking less for binary files
[ -x /usr/bin/lesspipe    ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon


# Environment variables
# --------------------------------------------------------------------

### man bash
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

### Global
export GOPATH=~/gosrc
mkdir -p $GOPATH
if [ -z "$PATH_EXPANDED" ]; then
  export PATH=~/bin:~/ruby:/opt/bin:/usr/local/bin:/usr/local/share/python:$GOPATH/bin:/usr/local/opt/go/libexec/bin:$PATH
  export PATH_EXPANDED=1
fi
export EDITOR=vim
export LANG=en_US.UTF-8
[ "$PLATFORM" = 'Darwin' ] ||
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib

### OS X
export COPYFILE_DISABLE=true

# Aliases
# --------------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd.='cd ..'
alias cd..='cd ..'
alias l='ls -alF'
alias ll='ls -l'
alias v='vim '
alias vi2='vi -O2 '
alias hc="history -c"
alias which='type -p'
alias k5='kill -9 %%'
alias temp='vim +"set buftype=nofile bufhidden=wipe nobuflisted noswapfile"'

[ "$PLATFORM" = 'Darwin' ] && alias tac='tail -r'

### Tmux
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"
tping() {
  for p in $(tmux list-windows -F "#{pane_id}"); do
    tmux send-keys -t $p Enter
  done
}

### Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi


# Prompt
# --------------------------------------------------------------------

if [ "$PLATFORM" = Linux ]; then
  PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
  PS1="$PS1\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
  ### git-prompt
  if [ ! -e ~/.git-prompt.sh ]; then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
  fi
  source ~/.git-prompt.sh
  PROMPT_COMMAND='printf "\[\e[38;5;59m\]%$(($COLUMNS - 4))s\r" "$(__git_ps1) ($(date +%m/%d\ %H:%M:%S))"'
  PS1="\[\e[34m\]\u\[\e[1;32m\]@\[\e[0;33m\]\h\[\e[35m\]:"
  PS1="$PS1\[\e[m\]\w\[\e[1;31m\]> \[\e[0m\]"
fi

# Tmux tile
# --------------------------------------------------------------------

tt() {
  if [ $# -lt 1 ]; then
    echo 'usage: tt <commands...>'
    return 1
  fi

  local head="$1"
  local tail='echo -n Press enter to finish.; read'

  while [ $# -gt 1 ]; do
    shift
    tmux split-window "$SHELL -ci \"$1; $tail\""
    tmux select-layout tiled > /dev/null
  done

  tmux set-window-option synchronize-panes on > /dev/null
  $SHELL -ci "$head; $tail"
}


# Shortcut functions
# --------------------------------------------------------------------

viw() {
  vim `which "$1"`
}

gd() {
  [ "$1" ] && cd *$1*
}

csbuild() {
  [ $# -eq 0 ] && return

  cmd="find `pwd`"
  for ext in $@; do
    cmd=" $cmd -name '*.$ext' -o"
  done
  echo ${cmd: 0: ${#cmd} - 3}
  eval "${cmd: 0: ${#cmd} - 3}" > cscope.files &&
  cscope -b -q && rm cscope.files
}

gems() {
  for v in 2.0.0 1.8.7 jruby 1.9.3; do
    rvm use $v
    gem $@
  done
}

rakes() {
  for v in 2.0.0 1.8.7 jruby 1.9.3; do
    rvm use $v
    rake $@
  done
}

tx() {
  tmux splitw "$*; echo -n Press enter to finish.; read"
  tmux select-layout tiled
  tmux last-pane
}

rvm() {
  # Load RVM into a shell session *as a function*
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    unset -f rvm

    source "$HOME/.rvm/scripts/rvm"
    # Add RVM to PATH for scripting
    PATH=$PATH:$HOME/.rvm/bin
    rvm $@
  fi
}

gitzip() {
  git archive -o $(basename $PWD).zip HEAD
}

gittgz() {
  git archive -o $(basename $PWD).tgz HEAD
}

gitdiffb() {
  if [ $# -ne 2 ]; then
    echo two branch names required
    return
  fi
  git log --graph \
  --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
  --abbrev-commit --date=relative $1..$2
}

alias gitv='git log --decorate=full --graph --oneline'

miniprompt() {
  unset PROMPT_COMMAND
  PS1="\[\e[38;5;168m\]> \[\e[0m\]"
}

repeat() {
  while [ -n "$2" ]; do
    eval "$2"
    sleep $1
  done
}

EXTRA=$BASE/bashrc-extra
[ -f "$EXTRA" ] && source "$EXTRA"


# boot2docker
# --------------------------------------------------------------------
dockerinit() {
  $(boot2docker shellinit 2> /dev/null)
}


# fzf (https://github.com/junegunn/fzf)
# --------------------------------------------------------------------

export FZF_DEFAULT_OPTS='-x'

# fd - cd to selected directory
fd() {
  DIR=`find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf` \
    && cd "$DIR"
}

# fda - including hidden directories
fda() {
  DIR=`find ${1:-*} -type d 2> /dev/null | fzf` && cd "$DIR"
}

# Figlet font selector
fgl() {
  cd /usr/local/Cellar/figlet/*/share/figlet/fonts
  BASE=`pwd`
  figlet -f `ls *.flf | sort | fzf` $*
}

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +s +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

# fco - checkout git commit
fco() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --nth=1,2
  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

if [ -n "$TMUX_PANE" ]; then
  fzf_tmux_helper() {
    local sz=$1;  shift
    local cmd=$1; shift
    tmux split-window $sz \
      "bash -c \"\$(tmux send-keys -t $TMUX_PANE \"\$(source ~/.fzf.bash; $cmd)\" $*)\""
  }

  # https://github.com/wellle/tmux-complete.vim
  fzf_tmux_words() {
    fzf_tmux_helper \
      '-p 40' \
      'tmuxwords.rb --all --scroll 500 --min 5 | fzf --multi | paste -sd" " -'
  }

  # ftpane - switch pane (@george-b)
  ftpane() {
    local panes current_window current_pane target target_window target_pane
    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(tmux display-message -p '#I:#P')
    current_window=$(tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
      tmux select-pane -t ${target_window}.${target_pane}
    else
      tmux select-pane -t ${target_window}.${target_pane} &&
      tmux select-window -t $target_window
    fi
  }

  # Bind CTRL-X-CTRL-T to tmuxwords.sh
  bind '"\C-x\C-t": "$(fzf_tmux_words)\e\C-e"'
fi

# Switch tmux-sessions
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# Z integration
source $BASE/z.sh
unalias z 2> /dev/null
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s | sed 's/^[0-9,.]* *//')"
  else
    _z "$@"
  fi
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
