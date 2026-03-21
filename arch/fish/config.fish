# Source the default cachyOS config for fish, if available
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Make sure ssh-agent is available
if not set -q SSH_AGENT_PID
    ssh-agent -c | source >/dev/null 2>&1
end

# Make sure rbenv is initialized, if abailable
status --is-interactive; and type -q rbenv; and rbenv init - --no-rehash fish | source

# Include ~/.local/bin in the PATH
set -gx PATH $HOME/.local/bin $PATH

# === Aliases ===
alias vim nvim
alias d "git diff -v --color"
alias st "git status"
alias gl "git log --graph --abbrev-commit --decorate --pretty=format:'%Cgreen%h %Cred%an%Creset: %s %Cblue(%cr)%Creset %Cred%d%Creset'"

function d-single
    d $argv[1]^..$argv[1]
end
