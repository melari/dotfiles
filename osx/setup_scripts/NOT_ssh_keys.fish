#!/usr/bin/env fish

./1password.fish; or exit $status

mkdir -p ~/.not-ssh

lib/safelink.fish NOT_ssh/config ~/.not-ssh/config; or exit $status

# import_key(1password_name, file_name)
function import_key
    set item_name $argv[1]
    set ssh_file $HOME/.not-ssh/$argv[2]

    if test -f $ssh_file
        echo "$ssh_file already exists, skipping"
        return 0
    end

    op item get "$item_name" --fields "private key" --reveal \
        | sed '1s/^"//' \
        | sed '$s/"$//' \
        | sed '/^[[:space:]]*$/d' >$ssh_file; or return $status

    op item get "$item_name" --fields "public key" \
        | sed '1s/^"//' \
        | sed '$s/"$//' \
        | sed '/^[[:space:]]*$/d' >$ssh_file.pub; or return $status

    chmod 600 $ssh_file; or return $status
    chmod 644 $ssh_file.pub; or return $status

    echo "🔑 Added $argv[2] SSH key"
end

import_key "Loft Hosting Ottawa SSH Key" loft-hosting-ottawa
import_key "Eth Node SSH Key" eth-node
import_key "Github Shared SSH Key" github-shared

echo "👉 You need to manually add Include ~/.not-ssh/config into your ~/.ssh/config file."
echo "(press any key to continue)"
read --silent --nchars 1 -P ""
