---
description: "jj（Jujutsu VCS）の基本知識と日常操作ガイド。jj管理プロジェクトでの作業時に使用。"
---

# jj ガイド

## 基本概念

- 全変更が自動的に @ コミットに入るのが大前提（ステージング概念なし）
- @コミット ≒ 自動スナップショット機能付きワーキングツリー（編集するたびに自動amend）
- `jj new` — 新しい空コミットを作る
- `jj edit` — 指定コミットを編集する ≒ git switch

**例：**
```bash
# 編集中の変更は自動的に @ に記録される
echo "content" > file.txt    # 変更は即座に @ に反映
jj st                         # 変更を確認

# 変更を確定して次に進む
jj commit -m "Add file"       # @ の変更をコミット、新しい @ を作成

# 新しいコミットを作って作業開始
jj new -m "Next feature"      # 空コミットを作成して作業開始
```

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

**例：**
```bash
jj commit -i              # TUIでhunkを選択してコミット（残りは新@へ）
jj split -i               # 現在の変更を2つのコミットに分割
```

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

**例：**
```bash
# 直前のコミットに変更を追加（git commit --amend相当）
jj squash

# 複数のコミットをまとめる
jj squash --from <newer-commit> --into <older-commit>

# 変更を適切な祖先コミットに自動分配
jj absorb                 # 各行の変更履歴を辿って最適なコミットに吸収
```

## 操作の取り消し

```bash
jj undo                    # 直前の操作を取り消す
jj redo                    # undoの取り消し
jj op restore OP_ID        # 特定操作時点にリポジトリ全体を戻す
jj op log                  # 操作ログ
jj op show -p              # 最新操作の詳細（パッチ付き）
```

**例：**
```bash
# コミットを間違えた場合
jj commit -m "Wrong message"
jj undo                   # 直前のコミットを取り消す

# 複数の操作を一度に取り消す
jj op log                 # 操作履歴を確認
jj op restore xyz123      # 特定の時点に完全復元
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

---

> 式言語（Fileset/Revset/Template）の詳細や高度なトラブルシューティングは、`jj-expert` エージェントに問い合わせてください。
