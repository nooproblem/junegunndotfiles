#####################################################################
# Ubuntu
#####################################################################

# If not running interactively, don't do anything
#################################################
if [[ -n $PS1 ]]; then # RVM

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#####################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Keystrokes
stty -ixoff -ixon

# Global
export PATH=~/bin:~/bash:~/perl:~/python:~/ruby:~/opt/bin:/opt/bin:/usr/local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
export EDITOR=vim
export LANG=en_US.UTF-8

# Ruby
export RUBYLIB=~/ruby

# Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias l='ls -alF'
alias ll='ls -l'
alias v='vim '
alias vi2='vi -O2 '
alias hc="history -c"
alias which='type -p'

[ `uname -s` = 'Darwin' ] && alias ls='ls -G'
gd() {
	[ "$1" ] && cd *$1*
}

# Prompt
# PS1='\[\033k\033\\\]' # SCREEN TRICK => TMUXIFIED
if [ `uname -s` = "Linux" ]; then
	#PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:\[\e[0;38m\]\w\[\e[1;35m\]"$PS1"> \[\e[0m\]"
	PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
	#PS1="\[\e[1;34m\]\u\[\e[0;32m\]@\[\e[0;33m\]\h\[\e[1;30m\]:\[\e[0;37m\]\w\[\e[0;31m\]"$PS1"> \[\e[0m\]"
	PS1="\[\e[1;34m\]\u\[\e[0;32m\]@\[\e[0;33m\]\h\[\e[1;30m\]:\[\e[0;37m\]\w\[\e[0;31m\]> \[\e[0m\]"
fi

fi # RVM
#################################################

EXTRA=$(dirname $(readlink $BASH_SOURCE))/bashrc_extra
if [ -f "$EXTRA" ]; then
	source "$EXTRA"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
rvm use 1.9.3 > /dev/null

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export COPYFILE_DISABLE=true
