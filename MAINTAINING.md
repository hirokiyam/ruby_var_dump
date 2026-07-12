# メンテナ向けメモ (MAINTAINING)

このgemの開発のための覚え書きです。（このファイルはgemには同梱されません）

## ディレクトリ構造（入れ子になっている点に注意）

```
ruby_var_dump/                          ← git リポジトリのルート（外側）
├── MAINTAINING.md                       ← このファイル
├── CHANGELOG.md  → ruby_var_dump/CHANGELOG.md   (シンボリックリンク)
├── README.md     → ruby_var_dump/README.md      (シンボリックリンク)
└── ruby_var_dump/                      ← gem のルート（内側。gemspec・lib・spec がある）
    ├── ruby_var_dump.gemspec
    ├── CHANGELOG.md                     ← 実体
    ├── README.md                        ← 実体
    └── lib/ruby_var_dump.rb
```

- gitリポジトリのルートは外側、gemのルートは内側（`ruby_var_dump/ruby_var_dump/`）。
- `gem build` は内側ディレクトリの git 管理ファイルだけをパッケージする（gemspec が `git ls-files` を内側で実行するため）。

## どこを編集すべきか

- CHANGELOG.md / README.md の実体は「内側」にある。 編集はどちらのパスから開いても同じ実体を編集する（外側はシンボリックリンクで内側を指しているため）。
- ソースコードは `ruby_var_dump/lib/ruby_var_dump.rb`。

## シンボリックリンクの注意点

外側の `CHANGELOG.md` / `README.md` は内側へのシンボリックリンク（二重管理を避けるため実体は1つ）。

- 種類の確認: `ls -l`（先頭が `l` でリンク、`-` で通常ファイル）。
- 編集は基本的にそのまま実体に書き込まれるが、一部のエディタの「アトミック保存」でリンクが通常ファイルに置き換わり、二重管理が復活することがある。
- もし外側が通常ファイルに戻ってしまったら、貼り直す:
  ```bash
  rm CHANGELOG.md README.md
  ln -s ruby_var_dump/CHANGELOG.md CHANGELOG.md
  ln -s ruby_var_dump/README.md README.md
  ```
- git 上ではリンクへの変更が `typechange` として表示される。

## リリース手順

1. `ruby_var_dump/lib/ruby_var_dump/version.rb` の `VERSION` を更新。
2. `ruby_var_dump/CHANGELOG.md`（＝外側からも見える実体）に変更点を追記。
3. 必要なら `ruby_var_dump/README.md` も更新。
4. gem をビルド:
   ```bash
   cd ruby_var_dump
   gem build ruby_var_dump.gemspec
   ```
5. 動作確認（テスト）:
   ```bash
   cd ruby_var_dump
   bundle exec rspec
   ```
6. 公開する場合: `gem push ruby_var_dump-<version>.gem`

## 機能メモ

- `require "ruby_var_dump"` した時点で自動的に `Object.include(RubyVarDump)` される（初期化ファイル不要）。
- `RubyVarDump.assoc` で Active Record のアソシエーション出力を切り替え。デフォルト `1`(ON)、`0` で OFF。
- 出力メソッドは `vdump` と、そのエイリアス `vpp`。
