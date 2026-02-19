# claude-plugin-jj

[English](README.md) | [日本語](README.ja.md)

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
- **jj-expert はより広範な知識を持つエージェント** — 高度な操作やトラブルシューティングのエキスパート支援を提供。

## コンポーネント

### jj-guard フック（PreToolUse）

jj 管理プロジェクト（`.jj` ディレクトリが存在）で git コマンドの実行を検出しブロックする。**気づきのためのガードであり、絶対禁止ではない。**

- `jj git push` 等の jj 経由の git 操作は許可
- deny 時はスキルを案内し、具体的な対応は jj-guide に委ねる
- git でしかできない操作（submodule, lfs 等）は `:;git` で簡単に回避可能（意図的な設計）

### jj-guide スキル

jj の基本概念、Git→jj 対応表、日常操作のリファレンスを提供する。deny 時の知識補完も兼ねる。

### jj-expert エージェント

より広範な jj 知識を持つエージェント。複雑な問い合わせやトラブルシューティング時に起動される。

### インストール

```bash
claude plugin marketplace add kawaz/claude-plugin-jj
claude plugin install jj@claude-plugin-jj
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
