# Interactive prompt

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%F{200}[%b%u%c]%f'
zstyle ':vcs_info:*' enable git

PROMPT='%F{150}%B%~%b%f%F{100}|%f$vcs_info_msg_0_%F{100}>%f '

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

d-single() {
  d $@^..$@
}
