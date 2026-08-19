#!/usr/bin/env bash
set -euo pipefail

# Backwards-compatible entrypoint. The old implementation could delete
# existing skill directories; agent-share deliberately refuses to do that.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/bin/agent-share" sync
