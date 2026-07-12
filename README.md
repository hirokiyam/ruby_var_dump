# ruby_var_dump

A Ruby gem for detailed debugging and inspection of objects, mimicking PHP's `var_dump` function.

## Usage

Just install the gem and require it — `vdump` (and its alias `vpp`) become available on every object automatically. Here's how to get started:

### Installation

First, add the gem to your application's Gemfile:

```ruby
gem 'ruby_var_dump'
```

Then, run the following command to install the gem:

```bash
bundle install
```

Alternatively, you can install it yourself as:

```bash
gem install ruby_var_dump
```

### Example Setup

Here's a simple example. Once the gem is required, `vdump` / `vpp` can be called from anywhere — no `include` is needed:

```ruby
require 'ruby_var_dump'

class ExampleClass
  def show_example_usage
    # Define some example data
    my_hash = {key1: "value1", key2: 123}
    my_array = [1, 2, 3, {nested_key: "nested_value"}]

    # Use the vdump method to output the structure of these objects
    # Or you can use the 'vpp' method as an alias
    vdump my_hash
    vdump my_array

    # Alternatively, use the 'vpp' method to achieve the same output
    vpp my_hash
    vpp my_array
  end
end
```

Output:

```
{
  :key1 => "value1",
  :key2 => 123
}
=> nil

[
  1,
  2,
  3,
  {
    :nested_key => "nested_value"
  }
]
=> nil
```

### Usage in Rails

Just add it to your `Gemfile`:

```ruby
gem 'ruby_var_dump'
```

That's it. When the gem is loaded, it automatically includes the `RubyVarDump` module into the Ruby `Object` class, so the `vdump` method is globally available across all objects. **No initializer file is required.**

> In earlier versions you had to create `config/initializers/setup_ruby_var_dump.rb` and write `Object.include RubyVarDump` yourself. This is no longer necessary.

> **Note (behavior change in 0.4.0):** Requiring the gem now automatically includes `RubyVarDump` into `Object`.
> If you previously relied on `require` NOT modifying `Object`, be aware of it.

### Toggling Active Record association output

By default, when you dump an Active Record object its associations (`belongs_to` / `has_one` / `has_many` / `has_and_belongs_to_many`) are also printed. You can turn this off globally via `RubyVarDump.assoc`:

```ruby
RubyVarDump.assoc = 0   # hide associations
vpp my_record           # only the record's own attributes are printed

RubyVarDump.assoc = 1   # show associations again (this is the default)
vpp my_record
```

The default is `1` (ON).

### method

#### vdump ( or 'vpp' as alias )
You can use `vdump` or `vpp` to print the structure of any Ruby object. Here's how you can use it:

vdump or vpp (alias of vdump)
```ruby
vdump "abc"
 or
vpp "abc"
```

Output
```
"abc"
=> nil
```

Example with a more complex structure:
```ruby
item = {key1: "value1", key2: 1024, key3: {key4: {key5: "value5", key6: [11,22]}}}

vdump item
 or
vpp item
```

Output:

```
{
  :key1 => "value1",
  :key2 => 1024,
  :key3 => {
    :key4 => {
      :key5 => "value5",
      :key6 => [
        11,
        22
      ]
    }
  }
}
=> nil
```

### vpp (alias of vdump)
`vpp`, an alias for `vdump`, stands for "visual pretty print" and can be used interchangeably to achieve the same functionality. 


### versions

In this way, arrays, hashes, and other objects are output graphically.

Version 0.1.4: added support for Active Record output.

Version 0.1.5: changed the method name from dump to vdump.

Version 0.1.6: created the alias vpp, which stands for "visual pretty print".

Version 0.2.0: modified to pick up belongs_to and has_one.

Version 0.3.0: added header at the beginning of output and footer at the end of output

Version 0.4.0: the gem now automatically includes `RubyVarDump` into `Object` on require, so no initializer file (`Object.include RubyVarDump`) is needed anymore. Also added the `RubyVarDump.assoc` setting to toggle Active Record association output (default `1` = ON; set to `0` to hide associations)



# ruby_var_dump 日本語の説明

PHPの `var_dump` 関数を模倣した、オブジェクトの詳細なデバッグ・検査を行うためのRuby用Gemです。

## 使用方法

gem をインストールして `require` するだけで、`vdump`（およびそのエイリアス `vpp`）がすべてのオブジェクトで自動的に使えるようになります。以下で始め方を説明します。

### インストール

まず、アプリケーションのGemfileに以下を追加してください：

```ruby
gem 'ruby_var_dump'
```

その後、以下のコマンドでインストール：

```bash
bundle install
```

もしくは、以下のコマンドで手動インストールも可能です：

```bash
gem install ruby_var_dump
```

### 使用例

`require` した後は、`vdump` / `vpp` をどこからでも呼び出せます（`include` は不要です）：

```ruby
require 'ruby_var_dump'

class ExampleClass
  def show_example_usage
    # 出力例のデータ
    my_hash = {key1: "value1", key2: 123}
    my_array = [1, 2, 3, {nested_key: "nested_value"}]

    # vdump または vpp メソッドで構造を出力
    vdump my_hash
    vdump my_array

    # vpp を使用しても同様の出力
    vpp my_hash
    vpp my_array
  end
end
```

出力例：

```
{
  :key1 => "value1",
  :key2 => 123
}
=> nil

[
  1,
  2,
  3,
  {
    :nested_key => "nested_value"
  }
]
=> nil
```

### Railsでの利用方法

`Gemfile` に追加するだけです：

```ruby
gem 'ruby_var_dump'
```

これで完了です。gem が読み込まれると自動的に RubyVarDump モジュールが Rubyの `Object` クラスにインクルードされ、アプリケーション全体で `vdump` メソッドが利用可能になります。

> 以前のバージョンでは `config/initializers/setup_ruby_var_dump.rb` を作成し、自分で `Object.include RubyVarDump` を記述する必要がありましたが、現在は不要になりました。

> **注意（0.4.0での挙動変化）:** gem を require すると自動的に `RubyVarDump` が `Object` にインクルードされます。
`require` が `Object` を変更しないことを前提にしていた場合はご注意ください。

### アソシエーション表示の切り替え

Active Record オブジェクトをダンプすると、デフォルトではアソシエーション（`belongs_to` / `has_one` / `has_many` / `has_and_belongs_to_many`）も一緒に出力されます。これは `RubyVarDump.assoc` でグローバルに切り替えられます：

```ruby
RubyVarDump.assoc = 0   # アソシエーションを非表示
vpp my_record           # そのレコード自身の属性だけを出力

RubyVarDump.assoc = 1   # 再びアソシエーションを表示（デフォルト）
vpp my_record
```

デフォルトは `1`（ON）です。

### 提供メソッド

#### vdump（およびそのエイリアス `vpp`）

`vdump` または `vpp` を使用して、任意のRubyオブジェクトの構造を視覚的に出力できます。

```ruby
vdump "abc"
# または
vpp "abc"
```

出力例：

```
"abc"
=> nil
```

複雑な構造の変数の出力例：

```ruby
item = {key1: "value1", key2: 1024, key3: {key4: {key5: "value5", key6: [11,22]}}}

vdump item
# または
vpp item
```

出力：

```
{
  :key1 => "value1",
  :key2 => 1024,
  :key3 => {
    :key4 => {
      :key5 => "value5",
      :key6 => [
        11,
        22
      ]
    }
  }
}
=> nil
```

### `vpp`（`vdump` の別名）

`vpp` は `visual pretty print` の略で、`vdump` と同じ機能を持つエイリアスメソッドです。

---

## バージョン履歴

このGemは、配列、ハッシュ、およびその他のオブジェクトの構造を視覚的に出力することができます。

- **v0.1.4**: Active Recordの出力に対応
- **v0.1.5**: メソッド名を `dump` から `vdump` に変更
- **v0.1.6**: `vpp`（visual pretty print）という別名を追加
- **v0.2.0**: `belongs_to` および `has_one` の関連を出力対象に追加
- **v0.3.0**: 出力の開始と終了時に区切り線を追加
- **v0.4.0**: require 時に自動的に `RubyVarDump` を `Object` へインクルードするようにし、初期化ファイル（`Object.include RubyVarDump`）を不要にした。あわせて、Active Record のアソシエーション出力を切り替える `RubyVarDump.assoc` 設定を追加（デフォルト `1`＝ON、`0` で非表示）
