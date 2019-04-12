# =====================================
# INSTALLATION INSTRUCTIONS
# =====================================
# Install exa on OSX:
#   $ brew install exa
# =====================================

# Detect Operating System
platform='UNKNOWN'
unamestr=`uname`
if [[ $unamestr == Darwin* ]]; then
  platform='osx'
elif [[ $unamestr == Linux* ]]; then
  platform='linux'
fi

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

d-single() {
  git diff $@^..$@ --color
}

merges-between() {
  git log $@..$@ --merges --pretty=format:'(%an) %s' | sed -e 's/#\([0-9]*\)/Shopify\/billing#\1/g'
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

# enable dev
if [[ -f /opt/dev/dev.sh ]]; then source /opt/dev/dev.sh; fi

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
alias couch="ssh couchpotato.loft.hosting"
alias sycamore="ssh sycamore.loft.hosting -p 20022"

# Git Alias
alias co="git checkout"
alias m="git checkout master"
alias branch="git branch --color"
alias d="git diff -v --color"
alias d-head="d-single HEAD"
alias d-branch="d master..."
alias st="git status"
alias gl="git log --graph --abbrev-commit --decorate --pretty=format:'%Cgreen%h %Cred%an%Creset: %s %Cblue(%cr)%Creset %Cred%d%Creset'"
alias lstash-save="git commit -am \"[UNFINISHED - LONG STASH]\" && st && branch"
alias lstash-apply="git reset --soft HEAD^ && st"
alias branch-cleanup="echo '===== cleaning branches =====' && git branch --merged | grep -v \"\*\" | xargs -n 1 git branch -d && git remote prune origin && echo '===== done. remaining branches: =====' && branch"
alias update-master="echo '===== updating master =====' && git checkout master && git pull origin master && dev up && branch-cleanup"
alias rebase-latest-master="update-master && echo '===== rebasing on new master =====' && git checkout - && git rebase master && echo '===== done ====='"
alias ci="git checkout -B $(whoami)-ci-test && git add -A && git commit -m "[WIP]" && git push origin +$(whoami)-ci-test && git reset --soft HEAD^ && git reset HEAD . && git checkout - && open 'https://buildkite.com/shopify/shopify-branches/builds?branch=$(whoami)-ci-test'"


# Rails Alias
alias dbmigrate="rake db:migrate && rake db:test:clone"
alias b="bundle exec"
alias r="b rake"
alias itest='b ruby -I"lib:test"'
alias cop='b rubocop'

# Russbot alias
alias russbot-ssh="ssh russbot-staging"
alias russbot-deploy="USER=caleb_simpson bundle exec cap staging deploy"
alias russbot-console="DISABLE_SPRING=1 USER=caleb_simpson bundle exec rails c -e stagingdb"
alias russbot-lhm="RAILS_ENV=stagingdb USER=caleb_simpson bundle exec rake lhm:run"
alias russbot-server="RAILS_ENV=stagingdb USER=caleb_simpson bundle exec rails s"

# Platform specific Alias
if [[ $platform == 'osx' ]]; then
  alias vim='nvim'
  alias l='exa -lhgbaF --git --color-scale --color always --group-directories-first'
  alias lsize='exa -lhgbaF --git --color-scale --color always --group-directories-first --sort=size -r'
fi

## Ruby GC
export RUBY_GC_HEAP_INIT_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000

# Setup FZF (including auto-completion and key bindings)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
