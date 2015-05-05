#etc/xdg/awesome/rc.lua

#Add custom directories to our executable PATH
export PATH=$PATH:~/scripts
export PATH=$PATH:~/bin

#Force git to use vim when asking for text input (commit messages)
export GIT_EDITOR="vim"
export SVN_EDITOR="vim"

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

diff-single() {
  git diff $@^..$@ --color
}

#Setup some basic colors (used in setting PS1)
RED="\[\033[0;31m\]" 
YELLOW="\[\033[0;33m\]" 
GREEN="\[\033[0;32m\]" 
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
AQUA="\[\033[0;36m\]"
BROWN="\[\033[0;33m\]" 
WHITE="\[\033[0;37m\]" 

# $COLOR for different colors
# \u for username
# \w for working directory
# \$(__git_ps1) for git branch
# ➜ in case you want the character sometime..
source ~/.git-completion.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
PS1="$GREEN\w$BROWN|$AQUA"'$(__git_ps1 "%s")'"$BROWN:: $WHITE"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Custom Alias #
alias t='gnome-terminal &'
alias chrome='chromium-browser &>/dev/null &'
alias l='ls -alF'
alias ..='cd ..'
alias resolution="xdpyinfo | grep 'dimensions:'"
alias search="gnome-search-tool"
alias image="fotoxx"
alias ipconfig="route -n"
alias s="gnome-open ~/Pictures/Schedule.png"
alias deb="sudo dpkg -i"
alias steam="steam steam://open/games &"
alias subl="subl . &"
alias resource="source ~/.bashrc"
alias bashrc="vim ~/.bashrc && resource"

# Git Alias
alias lstash-save="git commit -am \"[UNFINISHED - LONG STASH]\" && st && branch"
alias lstash-apply="git reset --soft HEAD^ && st"
alias co='git checkout'
alias branch='git branch -a --color'
alias diff="git diff --color"
alias gl="git log --graph --abbrev-commit --pretty=format:'%Cgreen%h %Cred%an%Creset: %s %Cblue(%cr)%Creset'"
alias st="git status"
alias allbranch="git branch -av --color"
alias branch-cleanup="git branch --merged | grep -v \"\*\" | xargs -n 1 git branch -d"
alias gupdate="git checkout master && git fetch && git merge origin/master && bundle install && bundle exec rake db:migrate"

# Rails Alias
alias dbmigrate="rake db:migrate && rake db:test:clone"
alias dbreset="rake db:schema:load && rake db:test:clone"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
