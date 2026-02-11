# claude-plugin-jj

jj（Jujutsu VCS）管理プロジェクトでの Claude Code 利用を支援するプラグイン。

## コンポーネント

### jj-guard フック

jj 管理プロジェクト（`.jj` ディレクトリが存在）で git コマンドの実行を検出し、対応する jj コマンドを提示してブロックする PreToolUse フック。

- `jj git push` 等の jj 経由の git 操作は許可
- git submodule, git lfs 等の jj 非対応操作はユーザー確認後に許可

### jj-guide スキル

jj の基本概念、Git→jj 対応表、日常操作のリファレンスを提供するスキル。jj 管理プロジェクトでの作業時に知識を注入する。

### jj-expert エージェント

式言語（Fileset/Revset/Template）の詳細リファレンスを内蔵した調査専門エージェント。複雑な問い合わせやトラブルシューティング時に起動される。

## インストール

```bash
claude plugin add --from github:kawaz/claude-plugin-jj
```

## ライセンス

MIT
