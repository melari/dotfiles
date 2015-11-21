# Detect Operating System
platform='UNKNOWN'
unamestr=`uname`
if [[ $unamestr == Darwin* ]]; then
  platform='osx'
elif [[ $unamestr == Linux* ]]; then
  platform='linux'
fi

# Enable rbenv
PATH=$PATH:$HOME/.rbenv/bin
eval "$(rbenv init -)"

# custom directories to our executable PATH
export PATH=$PATH:~/scripts
export PATH=$PATH:~/bin
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"

# Makes rake test have nice output.
export REPORTERS=1

#Force git to use vim when asking for text input (commit messages)
export GIT_EDITOR="vim"
export SVN_EDITOR="vim"

# If not running interactively, don't do anything more
[ -z "$PS1" ] && return

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
# Backup if __git_ps1 is not working for some reason:
#PS1="$RED[VAGRANT] $GREEN\w$BROWN|$AQUA"'$(parse_git_branch "%s")'"$BROWN:: $WHITE"

# Load the git completion file depending on OS.
if [[ $platform == 'osx' ]]; then
  source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
  source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
elif [[ $platform == 'linux' ]]; then
  source ~/.git-completion.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

# Preferred PS1 (has branch status built in):

if [[ $platform == 'osx' ]]; then
  PS1="$GREEN\w$BROWN|$AQUA"'$(__git_ps1 "%s")'"$BROWN:: $WHITE"
elif [[ $platform == 'linux' ]]; then
  PS1="$BLUE\w$RED|$AQUA"'$(__git_ps1 "%s")'"$RED:: $WHITE"
fi


# don't put duplicate lines in the history
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
alias open-again="open -n -a"
alias couch="ssh couchpotato.simpson.center"

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

# Russbot alias
alias russbot-ssh="ssh russbot-staging"
alias russbot-deploy="USER=caleb_simpson cap staging deploy" #Add SKIP_LHM=true, to deploy without running LHMs.
alias russbot-console="DISABLE_SPRING=1 USER=caleb_simpson bundle exec rails c -e stagingdb"
alias russbot-lhm="RAILS_ENV=stagingdb USER=caleb_simpson bundel exec rake lhm:run"

# Vagrant Alias
alias vap='cd ~/code/vagrant && git pull origin master && vagrant up --provision'
alias va='cd ~/code/vagrant && vagrant ssh'

## Ruby GC
export RUBY_GC_HEAP_INIT_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000