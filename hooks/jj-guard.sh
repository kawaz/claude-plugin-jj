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
suggest_deny 'このプロジェクトはjjで管理されています。gitではなくjjコマンドを使用してください。

## 対応表
  git status       → jj status (jj st)
  git log          → jj log
  git diff         → jj diff
  git add          → 不要（jjは自動追跡）
  git commit       → jj commit / jj describe
  git branch       → jj bookmark
  git push         → jj git push
  git fetch/pull   → jj git fetch
  git checkout     → jj new / jj edit
  git rebase       → 不要（jjは自動リベース）
  git stash        → 不要（作業内容は自動保存）
  git cherry-pick  → jj backout / jj duplicate
  git tag          → jj tag

## gitが本当に必要な場合
jjでは対応できない操作（例: git submodule, git lfs等）の場合は、
AskUserQuestionでユーザーに確認を取ってから実行してください。'
