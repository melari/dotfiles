#!/usr/bin/env fish

sudo pacman -Syu --needed --noconfirm docker iptables-nft docker-buildx; or exit $status

# Make sure the current user does not need sudo to run docker commands
sudo usermod -aG docker $USER

# Enable at boot and this session
sudo systemctl enable --now docker

echo ""
echo "👉 Docker is now installed, but usually requires a reboot after installing."
echo "<< Press any key to continue (with install, not restart) >>"
echo ""
read --silent --nchars 1
