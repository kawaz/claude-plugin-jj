# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Claude Code用プラグイン。jj (Jujutsu VCS) 管理下のリポジトリでgit誤使用を防止し、jjの知識を提供する。

インストール: `claude plugin marketplace add kawaz/claude-plugin-jj && claude plugin install jj@claude-plugin-jj`

## アーキテクチャ（3層構成）

| 層 | ファイル | 役割 |
|---|---|---|
| Hook (`jj-guard`) | `hooks/hooks.json` + `hooks/jj-guard.sh` | PreToolUseフックでBash内の`git `コマンドをブロック |
| Skill (`jj-guide`) | `skills/jj-guide/SKILL.md` | 基本操作リファレンス（Git→jjマッピング等） |
| Agent (`jj-expert`) | `agents/jj-expert.md` | 高度なrevset/fileset/template、GitHub PR連携等 |

**設計原則**: 3コンポーネントは1プラグインとしてバンドルされるため、相互の存在を前提にできる。hookのdenyメッセージはskillへ誘導するだけ、skillは基本に絞りagentへ委譲、agentは高度な内容に専念。情報を重複させない。

## 重要な設計判断

- **エスケープハッチ `:;git`**: guardは`git `で始まるコマンドのみブロック。`:;git`（no-op `:` + `;git`）で意図的にバイパス可能。git submodule/lfs等のgit専用操作のため。
- **非インタラクティブ操作**: AI agentは`-i`フラグ（TUI）を使えないため、agentにはfileset指定による非インタラクティブ代替を網羅。
- **agentのモデル**: `jj-expert`はsonnet指定（参照検索・コマンド構築が主目的のためコスト最適化）。

## ビルド・テスト

ビルドシステム・テスト・CIは無い。全ファイルが宣言的（shell script, JSON, Markdown）。

## 開発時の注意

- `plugin.json`にプラグインメタ情報（name, version）がある。**hook/skill/agentの内容を変更したら必ずpatch versionを上げること。**
- hookの動作条件: カレントディレクトリに`.jj`が存在 かつ コマンドが`git `で始まる場合にdeny。
- guardスクリプトは`jq`に依存（stdinからJSON解析）。
