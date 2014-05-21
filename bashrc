# .bashrc for OS X and Ubuntu
# ====================================================================
# - https://github.com/junegunn/dotfiles
# - junegunn.c@gmail.com

# System default
# --------------------------------------------------------------------

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc


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
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

### Global
export PATH=~/bin:~/ruby:/opt/bin:/usr/local/bin:$PATH:/usr/local/share/python
export EDITOR=vim
export LANG=en_US.UTF-8
[ "$PLATFORM" = 'Darwin' ] ||
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib

### OS X
export COPYFILE_DISABLE=true

### Jars
printf -v jars ":%s" ~/lib/*.jar
export CLASSPATH=$CLASSPATH$jars


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

### Tmux
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"

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

### git-prompt
[ -e ~/.git-prompt.sh ] && source ~/.git-prompt.sh

if [ "$PLATFORM" = Linux ]; then
  PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
  PS1="$PS1\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
  PROMPT_COMMAND='printf "\[\e[38;5;59m\]%$(($COLUMNS - 4))s\r" "$(__git_ps1) ($(date +%m/%d\ %H:%M:%S))"'
  PS1="\[\e[38;5;110m\]\u\[\e[38;5;108m\]@\[\e[38;5;186m\]\h\[\e[38;5;95m\]:"
  PS1="$PS1\[\e[38;5;252m\]\w\[\e[38;5;168m\]> \[\e[0m\]"
fi


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
  unset -f rvm

  # Load RVM into a shell session *as a function*
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

  # Add RVM to PATH for scripting
  PATH=$PATH:$HOME/.rvm/bin
  rvm $@
}

gitzip() {
  git archive -o $(basename $PWD).zip HEAD
}

gittgz() {
  git archive -o $(basename $PWD).tgz HEAD
}

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

EXTRA=$(dirname $(readlink $BASH_SOURCE))/bashrc-extra
[ -f "$EXTRA" ] && source "$EXTRA"


# fzf (https://github.com/junegunn/fzf)
# --------------------------------------------------------------------

export FZF_DEFAULT_OPTS='-x -s 10000'

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
    local sz=$1; shift
    local cmd=$1; shift
    tmux split-window $sz \
      "bash -c \"\$(tmux send-keys -t $TMUX_PANE \"\$(source ~/.fzf.bash; $cmd)\" $*)\""
  }

  # https://github.com/wellle/tmux-complete.vim
  fzf_tmux_words() {
    fzf_tmux_helper \
      '-p 40' \
      'tmuxwords.sh "" -a "-S -200" | grep -v "^.\{0,7\}$" | fzf --multi | paste -sd" " -'
  }

  # Bind CTRL-X-CTRL-T to tmuxwords.sh
  bind '"\C-x\C-t": "$(fzf_tmux_words)\e\C-e"'
fi

source ~/.fzf.bash
