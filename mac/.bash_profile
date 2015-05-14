[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

eval "$(rbenv init -)"

# custom directories to our executable PATH
export PATH=$PATH:~/scripts
export PATH=$PATH:~/bin
export PATH="/usr/local/mysql/bin:$PATH"

# Makes rake test have nice output.
export REPORTERS=1

#Force git to use vim when asking for text input (commit messages)
export GIT_EDITOR="vim"
export SVN_EDITOR="vim"

#Maven config
export M2_HOME="/home/vagrant/bin/apache-maven-3.2.1"
export M2="$M2_HOME/bin"
export PATH=$M2:$PATH

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
WHITE="\[\033[0;37m\]"
BROWN="\[\033[0;33m\]"

# $COLOR for different colors
# \u for username
# \w for working directory
# \$(__git_ps1) for git branch
# ➜  in case you want the character sometime..
#PS1="$GREEN\u: \w$AQUA\$(__git_ps1)$WHITE $ "

# Use built in OSX git completion file instead of the one from dotfiles repo.
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# Preferred PS1 (has branch status built in):
PS1="$GREEN\w$BROWN|$AQUA"'$(__git_ps1 "%s")'"$BROWN:: $WHITE"

# Backup if __git_ps1 is not working for some reason:
#PS1="$RED[VAGRANT] $GREEN\w$BROWN|$AQUA"'$(parse_git_branch "%s")'"$BROWN:: $WHITE"



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

# enable autocompletion for git
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi



# Custom Alias #
alias l='ls -alFG'
alias ls='ls -G'
alias ..='cd ..'
alias ipconfig="route -n"
alias allbranch="git branch -av --color"
alias resource="source ~/.bash_profile"
alias bashrc="vim ~/.bash_profile && resource"
alias notes="vim ~/notes"

# Git Alias
alias branch="git branch --color"
alias diff="git diff -v --color"
alias st="git status"
alias gl="git log --graph --abbrev-commit --pretty=format:'%Cgreen%h %Cred%an%Creset: %s %Cblue(%cr)%Creset'"
alias lstash-save="git commit -am \"[UNFINISHED - LONG STASH]\" && st && branch"
alias lstash-apply="git reset --soft HEAD^ && st"
alias branch-cleanup="git branch --merged | grep -v \"\*\" | xargs -n 1 git branch -d && git remote prune origin"
alias gupdate="git checkout master && git fetch && git merge origin/master && bundle install && bundle exec rake db:migrate"
alias ci="git checkout caleb-temp-test && git checkout - && git branch -f caleb-temp-test HEAD && git checkout - && git push origin caleb-temp-test -f && git checkout -"

# Rails Alias
alias dbmigrate="rake db:migrate && rake db:test:clone"
alias b="bundle exec"
alias flush_all='echo '\''flush_all'\'' | nc localhost 21211'
alias everqueen='RAILS ENV=test b rails s -p 3001 -P /tmp/pid'
alias test='b rake test TEST='
alias cop='b rubocop'

# Vagrant Alias
alias vap='cd ~/code/vagrant && vagrant up --provision'
alias va='cd ~/code/vagrant && vagrant ssh'

## Ruby GC
export RUBY_GC_HEAP_INIT_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000

alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"
alias irc="irssi"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Command Notes:
# In ssh:
# screen = open a detachable shell
# screen -r  = reopen your last screen
# <c-a><c-d> (while in a screen) = detact with killing
# <c-d> (while in a screen) = kill screen (???)
