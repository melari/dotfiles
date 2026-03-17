# Source the default cachyOS config for fish, if available
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
  source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Make sure ssh-agnet is available
if not set -q SSH_AGENT_PID
  ssh-agent -c | source > /dev/null 2>&1
end

# Include ~/.local/bin in the PATH
set -gx PATH $HOME/.local/bin $PATH
