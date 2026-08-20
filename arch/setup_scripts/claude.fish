#!/usr/bin/env fish

if not command -q claude
  curl -fsSL https://claude.ai/install.sh | bash
end
