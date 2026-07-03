#!/usr/bin/env fish

# Fish setup required to ensure ~/.local/bin is available
./fish.fish; or exit $status

lib/safelink.fish power_profile/update-power-profile ~/.local/bin/update-power-profile
sudo lib/safelink.fish power_profile/update-power-profile.service /etc/systemd/system/update-power-profile.service
sudo lib/safelink.fish power_profile/99-power-profile.rules /usr/lib/udev/rules.d/99-power-profile.rules

sudo systemctl daemon-reload
sudo udevadm control --reload-rules
sudo udevadm trigger
