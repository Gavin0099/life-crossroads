#!/usr/bin/env bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ ! -x "$TASK_ROOT/.venv/bin/python" ]; then
    echo '請先執行 bash scripts/governance-setup.sh' >&2
    exit 1
fi
exec "$TASK_ROOT/.venv/bin/python" "$TASK_ROOT/scripts/governance-check.py" "$@"
