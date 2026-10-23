#!/usr/bin/env bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$TASK_ROOT"
FRAMEWORK="$TASK_ROOT/additional/ai-governance-framework"
git submodule update --init -- additional/ai-governance-framework
if [ ! -x .venv/bin/python ]; then
    TASK_PYTHON="${AI_GOVERNANCE_PYTHON:-python3}"
    "$TASK_PYTHON" -c 'import sys; assert sys.version_info >= (3, 11), "Python 3.11+ required; set AI_GOVERNANCE_PYTHON"'
    "$TASK_PYTHON" -m venv .venv
fi
export AI_GOVERNANCE_PYTHON="$TASK_ROOT/.venv/bin/python"
export PATH="$TASK_ROOT/.venv/bin:$PATH"
export PYTHONPATH="$FRAMEWORK${PYTHONPATH:+:$PYTHONPATH}"
"$AI_GOVERNANCE_PYTHON" -c 'import sys; assert sys.version_info >= (3, 11), "Existing .venv requires Python 3.11+"'
"$AI_GOVERNANCE_PYTHON" -m pip install -r .governance/requirements.lock.txt
"$AI_GOVERNANCE_PYTHON" -m governance_tools.hook_installer --repo "$TASK_ROOT" --framework-root "$FRAMEWORK"
"$AI_GOVERNANCE_PYTHON" -m governance_tools.hook_install_validator --repo "$TASK_ROOT" --framework-root "$FRAMEWORK"
echo '本機 hooks 已安裝；Git 操作前請執行 source .venv/bin/activate。'
echo '執行 bash scripts/governance-check.sh 驗證導入狀態。'
