#!/usr/bin/env fish

set script_dir (dirname (realpath (status -f)))

# Copied rather than symlinked: systemd-logind.service runs with
# ProtectHome=yes, so /home is an empty tmpfs in its mount namespace and a
# symlink into the dotfiles would dangle and be silently ignored.
# Re-run this script after editing the drop-in.
# rm first: `install` would write through an existing symlink, leaving the
# broken link in place and quietly editing the dotfiles copy instead.
sudo rm -f /etc/systemd/logind.conf.d/10-power-key.conf; or exit $status
sudo install -D -m 644 $script_dir/../logind/10-power-key.conf /etc/systemd/logind.conf.d/10-power-key.conf; or exit $status
echo "📄 Installed /etc/systemd/logind.conf.d/10-power-key.conf"

sudo systemctl reload systemd-logind
