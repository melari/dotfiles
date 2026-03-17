#!/usr/bin/env fish

./1password.fish; or exit $status

mkdir -p ~/.ssh

lib/safelink.fish ssh/config ~/.ssh/config; or exit $status

# import_key(1password_name, file_name)
function import_key
    set item_name $argv[1]
    set ssh_file $HOME/.ssh/$argv[2]

    if test -f $ssh_file
        echo "$ssh_file already exists, skipping"
        return 0
    end

    op item get "$item_name" --fields "private key" --reveal \
    | sed '1s/^"//' \
    | sed '$s/"$//' \
    | sed '/^[[:space:]]*$/d' \
    > $ssh_file; or return $status

    op item get "$item_name" --fields "public key" \
    | sed '1s/^"//' \
    | sed '$s/"$//' \
    | sed '/^[[:space:]]*$/d' \
    > $ssh_file.pub; or return $status

    chmod 600 $ssh_file; or return $status
    chmod 644 $ssh_file.pub; or return $status

    echo "🔑 Added $argv[2] SSH key"
end

import_key "Loft Hosting Ottawa SSH Key" "loft-hosting-ottawa"
import_key "Eth Node SSH Key" "eth-node"
import_key "Github Shared SSH Key" "github-shared"
