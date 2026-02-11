#!/bin/bash
# PreToolUse hook: jj管理プロジェクトでのgit誤操作を防止
#
# .jjディレクトリが存在するプロジェクトで、コマンドが "git " で始まる場合に
# ブロックしてjjの対応コマンドを提示する。

set -euo pipefail

suggest_deny() {
    local reason="$1"
    jq -cn \
        --arg reason "$reason" \
        '{
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": $reason
            }
        }'
    exit 1
}

input=$(</dev/stdin)
command=$(jq -r '.tool_input.command // empty' <<< "$input")

# コマンドが空なら許可
[[ -z "$command" ]] && exit 0

# .jjディレクトリが無ければ許可（jj管理外）
[[ ! -d ".jj" ]] && exit 0

# コマンドが "git " で始まる場合のみブロック
[[ "$command" != git\ * ]] && exit 0

# ブロック: jj対応コマンドを提示
suggest_deny 'jj管理プロジェクトです。gitではなくjjを使ってください。jj:jj-guide スキルを参照。gitでしかできない操作は :;git cmd で回避可能。'
