# .bashrc for OS X and Ubuntu
# ====================================================================
# - https://github.com/junegunn/dotfiles
# - junegunn.c@gmail.com

# System default
# --------------------------------------------------------------------

[ -z ${PLATFORM+x} ] && export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

[ -f "${BASH_SOURCE[0]}" ] && BASE=$(dirname "$(readlink "${BASH_SOURCE[0]}")") ||
  BASE=$(dirname "$(readlink ~/.bashrc)")

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
export EDITOR=vim
mkdir -p $GOPATH
if [ "$PLATFORM" = 'Darwin' ]; then
  export PATH=~/bin:/usr/local/lib/ruby/gems/3.0.0/bin:/usr/local/opt/ruby/bin:$GOPATH/bin:$PATH
else
  export PATH=~/bin:$PATH
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib
fi
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### OS X
export COPYFILE_DISABLE=true
export BASH_SILENCE_DEPRECATION_WARNING=1

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
alias vi=$EDITOR
alias vim=$EDITOR
alias which='type -p'
alias k5='kill -9 %%'
alias gv='vim +GV +"autocmd BufWipeout <buffer> qall"'
alias gpob='git push origin $(git branch --show-current)'

tally() {
  sort | uniq -c | sort -n
}

ext() {
  ext-all --exclude .git --exclude target --exclude "*.log"
}

ext-all() {
  local name=$(basename $(pwd))
  cd ..
  tar -cvzf "$name.tgz" $* --exclude "$name.tgz" "$name"
  cd -
  mv ../"$name".tgz .
}

temp() {
  vim +"set filetype=$1" +AutoSave /tmp/temp-$(date +'%Y%m%d-%H%M%S')
}

if [ "$PLATFORM" = 'Darwin' ]; then
  alias tac='tail -r'
  o() {
    open --reveal "${1:-.}"
  }
fi

### Tmux
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"
tping() {
  for p in $(tmux list-windows -F "#{pane_id}"); do
    tmux send-keys -t $p Enter
  done
}
tpingping() {
  [ $# -ne 1 ] && return
  while true; do
    echo -n '.'
    tmux send-keys -t $1 ' '
    sleep 10
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

### Ruby
alias bert='bundle exec rake test'
alias ber='bundle exec rake'
alias be='bundle exec'


# Prompt
# --------------------------------------------------------------------

if [ "$PLATFORM" = Linux ]; then
  PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
  PS1="$PS1\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
  ### git-prompt
  __git_ps1() { :;}
  if [ -e ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
  fi
  PS1='\[\e[34m\]\u\[\e[1;32m\]@\[\e[0;33m\]\h\[\e[35m\]:\[\e[m\]\w\[\e[1;30m\]$(__git_ps1)\[\e[1;31m\]> \[\e[0m\]'
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

tssh() {
  local arg commands
  commands=()
  for arg in "$@"; do
    commands+=("ssh $arg")
  done
  tt "${commands[@]}"
}


# Shortcut functions
# --------------------------------------------------------------------

..cd() {
  cd ..
  cd "$@"
}

_parent_dirs() {
  COMPREPLY=( $(cd ..; find . -mindepth 1 -maxdepth 1 -type d -print | cut -c3- | grep "^${COMP_WORDS[COMP_CWORD]}") )
}

complete -F _parent_dirs -o default -o bashdefault ..cd

viw() {
  vim "$(which "$1")"
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

tx() {
  tmux splitw "$*; echo -n Press enter to finish.; read"
  tmux select-layout tiled
  tmux last-pane
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

alias gitv='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

miniprompt() {
  unset PROMPT_COMMAND
  PS1="\[\e[38;5;168m\]$ \[\e[0m\]"
}

repeat() {
  local _
  for _ in $(seq $1); do
    eval "$2"
  done
}

make-patch() {
  local prefix="$(git log --oneline HEAD^.. | awk '{print $2}')"
  local suffix=
  for i in {2..10}; do
    local name=$prefix$suffix.patch
    [ -e "$name" ] || break
    suffix=-v$i
  done
  echo $name
  git format-patch HEAD^.. --stdout > "$name"
}

pbc() {
  perl -pe 'chomp if eof' | pbcopy
}

pbpatch() {
  pbpaste | patch -p1
}

cheap-bin() {
  local PID=$(jps -lv |
      fzf --height 30% --reverse --inline-info \
          --preview 'echo {}' --preview-window bottom:wrap | awk '{print $1}')
  [ -n "$PID" ] && jmap -dump:format=b,file=cheap.bin $PID
}

EXTRA=$BASE/bashrc-extra
[ -f "$EXTRA" ] && source "$EXTRA"


if [ "$PLATFORM" = 'Darwin' ]; then
  resizes() {
    mkdir -p out &&
    for jpg in *.JPG; do
      echo $jpg
      [ -e out/$jpg ] || sips -Z 2048 --setProperty formatOptions 80 $jpg --out out/$jpg
    done
  }

  j8() { export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home; }
  j11() { export JAVA_HOME= /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home; }
fi

jfr() {
  if [ $# -ne 1 ]; then
    echo 'usage: jfr DURATION'
    return 1
  fi
  local pid path
  pid=$(jcmd | grep -v jcmd | fzf --height 30% --reverse | cut -d' ' -f1)
  path="/tmp/jfr-$(date +'%Y%m%d-%H%M%S').jfr"
  date
  jcmd "$pid" JFR.start duration="${1:-60}s" filename="$path" || return
  while jcmd "$pid" JFR.check | grep running > /dev/null; do
    echo -n .
    sleep 1
  done
  echo
  open "$path"
}

jfr-remote() (
  set -x -o pipefail
  if [ $# -ne 3 ]; then
    echo 'usage: jfr-remote HOST SUDOUSER DURATION'
    return 1
  fi
  local pid path dur
  pid=$(ssh -t "$1" "sudo -i sudo -u $2 jcmd" 2> /dev/null | grep -v jcmd |
        fzf --height 30% --reverse | cut -d' ' -f1) || return 1
  path="/tmp/jfr-$(date +'%Y%m%d-%H%M%S').jfr"
  dur="${3:-60}s"
  date
  ssh -t "$1" "sudo -i sudo -u $2 jcmd $pid JFR.start duration=$dur filename=$path || return"
  sleep $dur
  sleep 3
  ssh -t "$1" "sudo -i sudo -u $2 chmod o+r $path"
  scp "$1:$path" /tmp && open "$path"
)

tail-until() (
  pattern=$1
  shift
  grep -m 1 "$pattern" <(exec tail -F "$@"); kill $!
)

w3mdump() {
  curl -s "$@" | w3m -dump -T text/html | perl -pe 's/(\+[0-9,.%]+)/\x1b[31;1m\1\x1b[m/g; s/(-[0-9,.%]+)/\x1b[34;1m\1\x1b[m/g;'
}


# fzf (https://github.com/junegunn/fzf)
# --------------------------------------------------------------------

pods() {
  FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
    fzf --info=inline --layout=reverse --header-lines=1 --border \
    --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
    --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
    --bind ctrl-/:toggle-preview \
    --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
    --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
}

all-pods() {
  FZF_DEFAULT_COMMAND='
    (echo CONTEXT NAMESPACE NAME READY STATUS RESTARTS AGE
     for context in $(kubectl config get-contexts --no-headers -o name | sort); do
       kubectl get pods --all-namespaces --no-headers --context "$context" | sed "s/^/${context%-context} /"
     done) 2> /dev/null | column -t
  ' fzf --info=inline --layout=reverse --header-lines=1 --border \
    --prompt 'all-pods> ' \
    --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
    --bind ctrl-/:toggle-preview \
    --bind 'enter:execute:kubectl exec -it --context {1}-context --namespace {2} {3} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --context {1}-context --namespace {2} {3}) > /dev/tty' \
    --bind 'ctrl-r:reload:eval "$FZF_DEFAULT_COMMAND"' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --tail=10000 --all-containers --context {1}-context --namespace {2} {3}' "$@"
}

Rg() {
  local selected=$(
    rg --column --line-number --no-heading --color=always --smart-case "$1" |
      fzf --ansi \
          --delimiter : \
          --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
          --preview-window '~3:+{2}+3/2'
  )
  [ -n "$selected" ] && $EDITOR "$selected"
}

RG() {
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="$1"
  local selected=$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' || true" \
      fzf --bind "change:reload:$RG_PREFIX {q} || true" \
          --ansi --disabled --query "$INITIAL_QUERY" \
          --delimiter : \
          --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
          --preview-window '~3:+{2}+3/2'
  )
  [ -n "$selected" ] && $EDITOR "$selected"
}

fzf-down() {
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}

export FZF_TMUX_OPTS='-p80%,60%'
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
fi

command -v bat  > /dev/null && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
command -v blsd > /dev/null && export FZF_ALT_C_COMMAND='blsd'
command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# Figlet font selector => copy to clipboard
fgl() (
  [ $# -eq 0 ] && return
  cd /usr/local/Cellar/figlet/*/share/figlet/fonts
  local font=$(ls *.flf | sort | fzf --no-multi --reverse --preview "figlet -f {} $@" --preview-window up) &&
  figlet -f "$font" "$@" | pbcopy
)

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") | sed '/^$/d' |
    fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*") || return
  git checkout $(echo "$target" | awk '{print $2}')
}

if [ -d ~/github/iTerm2-Color-Schemes/ ]; then
  ftheme() {
    local base
    base=~/github/iTerm2-Color-Schemes
    $base/tools/preview.rb "$(
      ls {$base/schemes,~/.vim/plugged/seoul256.vim/iterm2}/*.itermcolors | fzf)"
  }
fi

# Switch tmux-sessions
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# jq repl
fjq() {
  local TEMP QUERY
  TEMP=$(mktemp -t fjq)
  cat > "$TEMP"
  QUERY=$(
    jq -C . "$TEMP" |
      fzf --reverse --ansi --disabled \
      --prompt 'jq> ' --query '.' \
      --preview "set -x; jq -C {q} \"$TEMP\"" \
      --header 'Press CTRL-Y to copy expression to the clipboard and quit' \
      --bind 'ctrl-y:execute-silent(echo -n {q} | pbcopy)+abort' \
      --print-query | head -1
  )
  [ -n "$QUERY" ] && jq "$QUERY" "$TEMP"
}

# Z integration
source "$BASE/z.sh"
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# c - browse chrome history
c() {
  local cols sep
  export cols=$(( COLUMNS / 3 ))
  export sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select title, url from urls order by last_visit_time desc" |
  ruby -ne '
    cols = ENV["cols"].to_i
    title, url = $_.split(ENV["sep"])
    len = 0
    puts "\x1b[36m" + title.each_char.take_while { |e|
      if len < cols
        len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
      end
    }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
  fzf --ansi --multi --no-hscroll --tiebreak=index |
  sed 's#.*\(https*://\)#\1#' | xargs open
}

# so - my stackoverflow favorites
so() {
  $BASE/bin/stackoverflow-favorites |
    fzf --ansi --reverse --with-nth ..-2 --tac --tiebreak index |
    awk '{print $NF}' | while read -r line; do
      open "$line"
    done
}

# https://stackoverflow.com/a/18787544/755334
rpmx() {
  # brew install rpm2cpio
  rpm2cpio.pl "$1" | cpio -idmv
}

# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
  cut -c4- | sed 's/.* -> //'
}

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

# Extra
_gp() {
  ps -ef | fzf-down --header-lines 1 --info inline --layout reverse --multi |
    awk '{print $2}'
}

_gg() {
  _z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info --tac | sed 's/^[0-9,.]* *//'
}

if [[ $- =~ i ]]; then
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(_gf)\e\C-e\er"'
  bind '"\C-g\C-b": "$(_gb)\e\C-e\er"'
  bind '"\C-g\C-t": "$(_gt)\e\C-e\er"'
  bind '"\C-g\C-h": "$(_gh)\e\C-e\er"'
  bind '"\C-g\C-r": "$(_gr)\e\C-e\er"'
  bind '"\C-g\C-s": "$(_gs)\e\C-e\er"'

  # Extra
  bind '"\C-g\C-p": "$(_gp)\e\C-e\er"'
  bind '"\C-g\C-g": "$(_gg)\e\C-e\er"'
fi

[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . /usr/local/etc/profile.d/bash_completion.sh
[[ -r /usr/local/etc/bash_completion.d/kubectl ]] && . /usr/local/etc/bash_completion.d/kubectl
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if [[ $- == *i* ]]; then
  _fzf_setup_completion path git kubectl
  _fzf_setup_completion host tssh
fi

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {}' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    tssh)         fzf "$@" --preview 'dig {}' --bind 'alt-a:select-all' --multi ;;
    *)            fzf "$@" ;;
  esac
}

nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm "$@"
}
