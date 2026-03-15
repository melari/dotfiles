#!/usr/bin/env fish

# Fish setup required to ensure ~/.local/bin is available
./fish.fish; or exit $status

set target ~/.local/bin/loft-hosting

if test -f $target
    echo "✅ loft-hosting is already available"
    exit 0
end

curl -L https://loft.hosting/downloads/linux/loft-hosting -o $target

chmod +x $target

