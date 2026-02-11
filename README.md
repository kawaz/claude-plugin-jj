# claude-plugin-jj

jj（Jujutsu VCS）管理プロジェクトでの Claude Code 利用を支援するプラグイン。

## 設計思想

### 3層構造

Hook（保護）→ Skill（ガイド）→ Agent（専門家）の3層で段階的にサポートする。

| 層 | コンポーネント | 役割 |
|---|---|---|
| Hook | jj-guard | git 誤操作を実行前にブロック |
| Skill | jj-guide | 基本知識と日常操作リファレンス |
| Agent | jj-expert | 式言語の詳細・高度なトラブルシュート |

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

## インストール

```bash
claude plugin add --from github:kawaz/claude-plugin-jj
```

## ライセンス

MIT
