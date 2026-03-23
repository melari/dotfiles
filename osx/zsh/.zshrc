# Interactive prompt

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%F{200}[%b%u%c]%f'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='$'
    fi
}

PROMPT='%F{150}%B%~%b%f%F{100}|%f$vcs_info_msg_0_%F{100}>%f '

# Add ~/bin to PATH
export PATH="$HOME/bin:$PATH"

# Global
alias ls='ls -G'
alias ..='cd ..'
alias vim='nvim'

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rails
alias b='bundle exec'
alias r='bundle exec rake'

# Clio Tooling
alias t='~/bin/verify_all_changes --test-only'
alias tt='~/bin/verify_all_changes'
alias lint='~/bin/verify_all_changes --lint-only'
export BETA_CLI_EDITOR=nvim

# Git
alias branch='git branch --color'
alias d='git diff -v --color'
alias st='git status'
alias gl="git log --graph --abbrev-commit --decorate --pretty=format:'%Cgreen%h %Cred%an%Creset: %s %Cblue(%cr)%Creset %Cred%d%Creset'"
alias up="~/bin/branch-cleanup && dev setup && dev up"

d-single() {
  d $@^..$@
}

eval "$(dev _hook)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Enables autocomplete for git branches
if [ ! -f ~/.zsh/completion/_git ]; then
  echo "Downloading git completion script..."
  mkdir -p ~/.zsh/completion
  curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
     -o ~/.zsh/completion/git-completion.bash
  curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh \
     -o ~/.zsh/completion/_git
fi
fpath=(~/.zsh/completion $fpath)
export GIT_COMPLETION_BASH_SOURCE=~/.zsh/completion/git-completion.bash
autoload -Uz compinit
compinit


export PATH="$HOME/.local/bin:$PATH"

[[ -d "/opt/clio/bin/devxp" ]] && export PATH="/opt/clio/bin/devxp:$PATH"

# == CLIO_ANDROID_SETUP ==

# Android PATHs
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin/:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
