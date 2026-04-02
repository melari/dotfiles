#!/usr/bin/env fish

set email caleb@simpson.center

if not test -d "/Applications/1Password.app"
    brew install --cask 1password; or exit $status
end

if not command -q op
    brew install --cask 1password-cli; or exit $status
end

# Guide user through CLI integration setup
if op account list | grep $email
    echo "✅ 1password-cli is ready"
else
    echo ""
    echo "👉 Action Required: Open the 1password desktop app. Go to settings > developer, and turn on 'Integrate with 1password CLI'"
    echo ">> Press Enter When Completed <<"

    read -P "" _reply

    if not op account list | grep $email
        echo "ERROR - Make sure `op account list` is working, then try again."
        exit 1
    end

    echo "✅ 1password-cli is ready"
end
