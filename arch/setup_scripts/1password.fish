#!/usr/bin/env fish

# From https://support.1password.com/install-linux/#arch-linux
set pgp_key 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
set email caleb@simpson.center

# Package install
if not pacman -Qi 1password >/dev/null 2>&1; or not pacman -Qi 1password-cli >/dev/null 2>&1
	./yay.fish; or exit $status

	mkdir -p ~/temp
	cd ~/temp

	rm -rf 1password
	yay -G 1password
	if grep "^validpgpkeys=('$pgp_key')" 1password/PKGBUILD
	  echo "🎉 Validated 1password package is signed with known PGP key"
	  yay -S --needed --noconfirm 1password
	else
	  echo "DANGER: Unable to verify 1password PGP key. Aborting"
	  exit 1
	end

	rm -rf 1password-cli
	yay -G 1password-cli
	if grep "^validpgpkeys=('$pgp_key')" 1password-cli/PKGBUILD
	  echo "🎉 Validated 1password-cli package is signed with known PGP key"
	  yay -S --needed --noconfirm 1password-cli
	else
	  echo "DANGER: Unable to verify 1password-cli PGP key. Aborting"
	  exit 1
	end
end

# Guide user through CLI integration setup
if op account list | grep $email
	echo "✅ 1password-cli is ready"
else
	echo ""
	echo "👉 Action Required: Open the 1password desktop app. Go to settings > developer, and turn on 'Integrate witht 1password CLI'"
	echo ">> Press Enter When Completed <<"

	read -P "" _reply

	if not op account list | grep $email
	  echo "ERROR - Make sure `op account list` is working, then try again."
	  exit 1
	end

	echo "✅ 1password-cli is ready"
end

