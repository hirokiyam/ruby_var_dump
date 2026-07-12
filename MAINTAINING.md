# メンテナ向けメモ (MAINTAINING)

このgemの開発のための覚え書きです。（このファイルはgemには同梱されません）

## ディレクトリ構造（入れ子になっている点に注意）

```
ruby_var_dump/                          ← git リポジトリのルート（外側）
├── MAINTAINING.md                       ← このファイル
├── CHANGELOG.md                         ← 実体（GitHub / RubyGems の表示用）
├── README.md                            ← 実体（GitHub / RubyGems の表示用）
└── ruby_var_dump/                      ← gem のルート（内側。gemspec・lib・spec がある）
    ├── ruby_var_dump.gemspec
    ├── CHANGELOG.md                     ← 実体（gem 同梱用）
    ├── README.md                        ← 実体（gem 同梱用）
    └── lib/ruby_var_dump.rb
```

- gitリポジトリのルートは外側、gemのルートは内側（`ruby_var_dump/ruby_var_dump/`）。
- `gem build` は内側ディレクトリの git 管理ファイルだけをパッケージする（gemspec が `git ls-files` を内側で実行するため）。
- GitHub のリポジトリ表示や RubyGems の Changelog リンクは**外側**を参照し、gem 本体は**内側**を同梱する。

## どこを編集すべきか

- ソースコードは `ruby_var_dump/lib/ruby_var_dump.rb`。
- CHANGELOG.md / README.md は**外側と内側の2箇所に実体があり、同じ内容に保つ必要がある**（下記「二重管理」参照）。

## 二重管理について（重要）

CHANGELOG.md / README.md は外側（GitHub/RubyGems表示用）と内側（gem同梱用）に**同じ内容の実体を2つ**置いている。

- 理由: シンボリックリンクにすると GitHub / RubyGems で中身がレンダリングされず、リンク先文字列だけが表示されてしまうため、両方とも実体である必要がある。
- **編集したら必ず両方を同期すること。** 内側を正としてコピーする例:
  ```bash
  cp ruby_var_dump/CHANGELOG.md CHANGELOG.md
  cp ruby_var_dump/README.md README.md
  ```
- **TODO（次回）**: この二重管理はディレクトリの入れ子が原因。gem のルートをリポジトリ直下へ移す「フラット化」を行えば、実体が1箇所になり同期が不要になる。

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
