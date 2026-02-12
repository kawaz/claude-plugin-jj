---
description: "jj（Jujutsu VCS）の基本知識と日常操作ガイド。jj管理プロジェクトでの作業時に使用。"
---

# jj ガイド

## Git との根本的な違い

| Git | jj |
|---|---|
| HEAD + staging + working tree の3層 | `@`（ワーキングコピーコミット）に統一 |
| `git add` で明示的にステージ | 全変更を自動スナップショット（add不要） |
| commit hash のみ | Change ID（安定・rewrite不変）+ Commit ID |
| branch が中心 | bookmark は主にリモート同期用（自動移動しない） |
| コンフリクト = 操作中断 | コンフリクト = コミットに記録されたデータ（続行可能） |
| reflog から手動復元 | `jj undo` / `jj op restore` で完全復元 |

### Change ID vs Commit ID

| | Change ID | Commit ID |
|---|---|---|
| 表記 | k-z 文字（hex と視覚的に区別） | 通常の hex (0-9a-f) |
| 永続性 | rewrite しても**不変** | rewrite で**新ID** |
| 用途 | 日常作業（こちらを使う） | Git 互換が必要な場合 |

### Bookmark（Git branch 相当）

- **コミット作成時に自動移動しない**（Git branch との最大の違い）
- コミットが rewrite されると自動追従。abandon されると bookmark も削除
- 明示的に移動: `jj bookmark set <name> -r <rev>`

## 基本概念

- 全変更が自動的に @ コミットに入るのが大前提（ステージング概念なし）
- @コミット ≒ 自動スナップショット機能付きワーキングツリー（編集するたびに自動amend）
- `jj new` — 新しい空コミットを作る
- `jj edit` — 指定コミットを編集する ≒ git switch

## Git → jj 対応表

| Git | jj | 備考 |
|---|---|---|
| `git status` | `jj st` | |
| `git log` | `jj log` | |
| `git diff` | `jj diff` | |
| `git add` | 不要 | 自動追跡 |
| `git add . && git commit -m MSG` | `jj commit -m MSG` | |
| `git commit --amend -m MSG` | `jj describe -m MSG` | メッセージ変更のみ |
| `git commit -m MSG` | `jj describe -m MSG && jj new` | describe + new の2段階 |
| `git add -p && git commit` | `jj split` / `jj commit -i` | |
| `git branch` | `jj bookmark` (`jj b`) | |
| `git push` | `jj git push` | |
| `git fetch`/`pull` | `jj git fetch` | pull = fetch + rebase |
| `git checkout`/`switch` | `jj new` / `jj edit` | new=新コミット, edit=既存編集 |
| `git rebase` | `jj rebase` | 子孫は自動追従 |
| `git stash` | 不要 | 作業内容は自動で@に保存 |
| `git cherry-pick` | `jj duplicate` | `--onto`で挿入先指定可 |
| `git revert` | `jj revert` | 挿入先指定が必須(`--onto`/`-A`/`-B`) |
| `git reset --hard HEAD~1` | `jj abandon` | コミット破棄 |
| `git reflog` | `jj op log` | 操作ログ |
| `git blame FILE` | `jj file annotate FILE` | |
| `git grep PATTERN` | `jj file search PATTERN` | |
| `git restore -- FILE` | `jj restore FILE` | `--from @-` が省略時デフォルト |
| `git bisect` | `jj bisect run CMD` | 自動bisectのみ |

## jj 固有コマンド

| コマンド | 概要 |
|---|---|
| `jj absorb` | @の変更をhunk単位で祖先コミットへ自動分配 |
| `jj evolog` | changeの変遷履歴 |
| `jj parallelize` | 直列コミットを並列（兄弟）に変換 |
| `jj metaedit` | 内容を変えずメタデータだけ変更 |
| `jj diffedit` | diff editorでコミット内容を直接編集 |
| `jj fix` | 設定済みフォーマッタを一括適用 |

## REVSET 基本表現

| jj | Git相当 | 備考 |
|---|---|---|
| `@` | `HEAD` | ワーキングコピーコミットそのもの |
| `@-` | `HEAD~1` | 親コミット |
| `@--` | `HEAD~2` | 2つ前 |

## コミット作成/分割

### インタラクティブ
`jj split -i` / `jj commit -i` — TUIでhunk選択 → EDITOR起動
- `split` は2回description編集（`-m MSG`は1つ目に適用、2つ目は元descを維持）

### 非インタラクティブ
```bash
jj commit -m "msg" foo bar           # 指定ファイルをコミット、残りは新@へ
jj split  -m "msg" foo bar           # 同上だがbookmark挙動が異なる
jj commit -m MSG 'glob:src/**'       # filesetパターン
jj commit -m MSG '~foo'              # foo以外
```

### commit vs split の bookmark 挙動
- `split` — bookmarkがあれば子（残り側）に移動
- `commit` — bookmarkは移動しない

### split の挿入オプション
```bash
jj split --onto DEST       # 選択部分をDESTの子として挿入
jj split -A AFTER          # AFTERの後ろに挿入
jj split -B BEFORE         # BEFOREの前に挿入
jj split --parallel        # 親子ではなく兄弟に分割
```

## squash / absorb

```bash
jj squash                  # @の変更を親にまとめる（splitの逆）
jj squash -i               # インタラクティブに選択
jj squash --from A --into B  # AからBへ移動
jj absorb                  # @の各hunkを最後にその行を変更した祖先へ自動分配
```

## 操作の取り消し

```bash
jj undo                    # 直前の操作を取り消す
jj redo                    # undoの取り消し
jj op restore OP_ID        # 特定操作時点にリポジトリ全体を戻す
jj op log                  # 操作ログ
jj op show -p              # 最新操作の詳細（パッチ付き）
```

## op log からファイル復元

snapshotはjjコマンド実行時に記録される。コミット内の中間状態も取り出せる。

```bash
# snapshot の op-id だけ抽出
jj op log --no-graph -T 'if(self.snapshot(), self.id() ++ "\n")'

# 最後にFILEが存在していたsnapshotから復元
jj op log --no-graph -T 'if(self.snapshot(), self.id() ++ "\n")' | while read -r op; do
  if jj --at-op="$op" file show FILE >/dev/null 2>&1; then
    jj --at-op="$op" file show FILE > FILE
    break
  fi
done
```

注意: jjコマンドを挟まずにファイルを編集→削除した場合、中間状態はsnapshotに記録されない。

## 基本ワークフロー

### 新規作業の開始

```bash
jj new main -m "feat: add feature"   # mainから新コミット作成
# ... 作業（変更は自動で@に記録される）...
jj commit -m "feat: add feature"     # 確定して次の空コミットへ
```

### リモートとの同期

```bash
jj git fetch                          # リモートの変更を取得
jj rebase -o main                     # 必要ならmain上にrebase
jj git push                           # 送信
```

### 変更の修正

```bash
jj describe -m "new message"          # @のメッセージ変更
jj squash                             # @の変更を親に吸収（amend相当）
jj squash --into <rev>                # 特定の祖先に吸収（fixup相当）
```

---

> **以下の場合は `jj-expert` エージェントに問い合わせてください:**
> - 式言語（Revset / Fileset / Template）の詳細な構築
> - コンフリクト、divergence、bookmark conflict のトラブルシューティング
> - 複雑な履歴操作（rebase戦略、split/absorb の最適化）
> - 設定のカスタマイズや Git 連携の問題
