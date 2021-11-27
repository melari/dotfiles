# ==================================== COMMAND PROMPT =====================================
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
AQUA="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"
BROWN="\[\033[0;33m\]"

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
PS1="$GREEN\w$BROWN|$AQUA"'$(__git_ps1 "%s")'"$BROWN:: $WHITE"

# ================================= ALIASES =======================================

# Global
alias ls='ls -G'
alias ..='cd ..'
alias vim='nvim'

# Rails
alias b='bundle exec'
alias r='bundle exec rake'

# Git
alias branch='git branch --color'
alias d='git diff -v --color'
alias st='git status'
alias gl="git log --graph --abbrev-commit --decorate --pretty=format:'%Cgreen%h %Cred%an%Creset: %s %Cblue(%cr)%Creset %Cred%d%Creset'"
alias branch-cleanup="echo '===== cleaning branches =====' && git branch --merged | grep -v \"\*\" | xargs -n 1 git branch -d && git remote prune origin && echo '===== done. remaining branches: =====' && branch"
alias update-master="echo '===== updating master =====' && git checkout master && git pull origin master && dev up && branch-cleanup"
alias rebase-latest-master="update-master && echo '===== rebasing on new master =====' && git checkout - && git rebase master && echo '===== done ====='"
alias ci="git checkout -B $(whoami)-ci-test && git add -A && git commit -m "[WIP]" && git push origin +$(whoami)-ci-test && git reset --soft HEAD^ && git reset HEAD . && git checkout - && open 'https://buildkite.com/shopify/shopify-branches/builds?branch=$(whoami)-ci-test'"

export PATH=$PATH:~/bin

d-single() {
  d $@^..$@
}

# Russbot
alias russbot-ssh="ssh russbot-staging"
alias russbot-deploy="USER=caleb_simpson bundle exec cap staging deploy"

# ==================================== Golang =========================================
export GOPATH=$HOME/src/personal/go
export PATH=$PATH:~/src/personal/go/bin

# ==================================== END (BELOW ARE AUTO ADDED) =====================
