# claude-plugin-jj

[English](#english) | [日本語](#日本語)

## English

A Claude Code plugin that helps users work with jj (Jujutsu VCS) managed projects.

### Design Philosophy

#### 3-Layer Architecture

Hook (Protection) → Skill (Guide) → Agent (Expert) provides progressive support.

| Layer | Component | Role |
|---|---|---|
| Hook | jj-guard | Blocks Git command misuse before execution |
| Skill | jj-guide | Basic knowledge and daily operation reference |
| Agent | jj-expert | Agent with comprehensive advanced knowledge |

#### Benefits of Integrated Plugin

The hook, skill, and agent are designed to work together, enabling each component to rely on the others.

- **jj-guard deny messages are minimal** — Instead of cramming command-specific alternatives into messages, it simply guides users to the skill. This centralizes information and reduces maintenance costs.
- **jj-expert loads skill content on startup** — It gets basic knowledge from the skill and focuses on advanced topics like expression languages.

### Components

#### jj-guard Hook (PreToolUse)

Detects and blocks git command execution in jj-managed projects (where `.jj` directory exists). **It's a guard for awareness, not absolute prohibition.**

- Allows jj-mediated git operations like `jj git push`
- On denial, directs users to the skill for specific guidance
- Operations that can only be done with git (submodule, lfs, etc.) can be easily bypassed with `:;git` (intentional design)

#### jj-guide Skill

Provides basic jj concepts, Git→jj mapping table, and daily operation reference. Also serves as knowledge補完 when commands are denied.

#### jj-expert Agent

An investigation specialist agent with built-in detailed reference for expression languages (Fileset/Revset/Template). Activated for complex inquiries and troubleshooting.

### Installation

```bash
claude plugin add --from github:kawaz/claude-plugin-jj
```

### Usage

Once installed, the plugin automatically:
1. Prevents accidental git commands in jj repositories (via jj-guard hook)
2. Provides jj command references when needed (via jj-guide skill)
3. Offers expert assistance for advanced jj operations (via jj-expert agent)

### License

MIT

---

## 日本語

jj（Jujutsu VCS）管理プロジェクトでの Claude Code 利用を支援するプラグイン。

## 設計思想

### 3層構造

Hook（保護）→ Skill（ガイド）→ Agent（専門家）の3層で段階的にサポートする。

| 層 | コンポーネント | 役割 |
|---|---|---|
| Hook | jj-guard | git 誤操作を実行前にブロック |
| Skill | jj-guide | 基本知識と日常操作リファレンス |
| Agent | jj-expert | より網羅的な知識を備えたエージェント |

### プラグイン一体化の利点

hook・skill・agent がセットで導入される前提により、各コンポーネントが互いの存在を前提にした設計ができる。

- **jj-guard の deny メッセージは最小限** — コマンド別の代替案をメッセージに詰め込まず、スキルへ誘導するだけで済む。情報の一元管理でメンテコストを抑える。
- **jj-expert はスキルを初期化時に読み込む** — 基本知識をスキルから取得し、自身は式言語など高度な内容に集中する。

## コンポーネント

### jj-guard フック（PreToolUse）

jj 管理プロジェクト（`.jj` ディレクトリが存在）で git コマンドの実行を検出しブロックする。**気づきのためのガードであり、絶対禁止ではない。**

- `jj git push` 等の jj 経由の git 操作は許可
- deny 時はスキルを案内し、具体的な対応は jj-guide に委ねる
- git でしかできない操作（submodule, lfs 等）は `:;git` で簡単に回避可能（意図的な設計）

### jj-guide スキル

jj の基本概念、Git→jj 対応表、日常操作のリファレンスを提供する。deny 時の知識補完も兼ねる。

### jj-expert エージェント

式言語（Fileset/Revset/Template）の詳細リファレンスを内蔵した調査専門エージェント。複雑な問い合わせやトラブルシューティング時に起動される。

### インストール

```bash
claude plugin add --from github:kawaz/claude-plugin-jj
```

### 使い方

インストール後、プラグインは自動的に：
1. jjリポジトリでのgitコマンド誤操作を防止（jj-guard フック経由）
2. 必要に応じてjjコマンドリファレンスを提供（jj-guide スキル経由）
3. 高度なjj操作のエキスパート支援を提供（jj-expert エージェント経由）

### トラブルシューティング

#### git コマンドを実行する必要がある場合

jj が未対応の Git 機能（submodule, lfs 等）を使う必要がある場合は、`:;git` プレフィックスを使用してください：

```bash
:;git submodule update --init
:;git lfs pull
```

#### jj-guide スキルが見つからない

Claude Code で `jj:jj-guide` と入力してスキルを明示的に呼び出すことができます。

### ライセンス

MIT
