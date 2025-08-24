# ruby_var_dump

A Ruby gem for detailed debugging and inspection of objects, mimicking PHP's `var_dump` function.

## Usage

To utilize the RubyVarDump module for debugging Ruby objects, you need to include it directly within the class where you wish to use its methods. Here's how to get started:

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

### Including RubyVarDump

To make RubyVarDump methods accessible in your class, add `include RubyVarDump` at the top of your class definition to mix in the RubyVarDump module's methods. 
This will mix in the RubyVarDump module methods as instance methods in your class.

```ruby
include RubyVarDump
```

### Example Setup

Here's a simple example to demonstrate how to include and use the RubyVarDump in a Ruby class:

```ruby
require 'ruby_var_dump'

class ExampleClass
  include RubyVarDump # This line mixes in RubyVarDump methods

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

To use RubyVarDump in a Rails application, you need to set it up as a global mixin so that its functionality is available throughout your application. Follow these steps:

1. Create an initializer file in your Rails application:

```bash
touch config/initializers/setup_ruby_var_dump.rb
```

2. Open the newly created setup_ruby_var_dump.rb file and add the following lines:

```ruby
# config/initializers/setup_ruby_var_dump.rb
require 'ruby_var_dump'
Object.include RubyVarDump
```
This setup will include the RubyVarDump module into the Ruby Object class, making the vdump method globally available across all objects within your Rails application.


### One-liner for steps 1 and 2
If you want to execute steps 1 and 2 in a one-liner command, run this:

```ruby
echo -e "# config/initializers/setup_ruby_var_dump.rb\nrequire 'ruby_var_dump'\nObject.include RubyVarDump" > config/initializers/setup_ruby_var_dump.rb
```

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



# ruby_var_dump 日本語の説明

PHPの `var_dump` 関数を模倣した、オブジェクトの詳細なデバッグ・検査を行うためのRuby用Gemです。

## 使用方法

Rubyのオブジェクトをデバッグするために RubyVarDump モジュールを使用するには、メソッドを使いたいクラスに直接インクルードしてください。

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

### RubyVarDumpのインクルード

クラス内で RubyVarDump のメソッドを使用できるようにするには、クラス定義の先頭に `include RubyVarDump` を追加してください。
これにより、RubyVarDumpモジュールのメソッドがインスタンスメソッドとして使用できるようになります。

```ruby
include RubyVarDump
```

### 使用例

以下は Ruby クラス内で RubyVarDump をインクルードし、使用する例です：

```ruby
require 'ruby_var_dump'

class ExampleClass
  include RubyVarDump # RubyVarDumpのメソッドを組み込む

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

RailsアプリケーションでRubyVarDumpを使用するには、アプリケーション全体でその機能が利用できるように、グローバルミックスインとして設定する必要があります。以下の手順に従ってください。

1. 初期化ファイルを作成(Macを想定。適宜、ファイル config/initializers/setup_ruby_var_dump.rb を作成してください)：

```bash
touch config/initializers/setup_ruby_var_dump.rb
```

2. 作成した `setup_ruby_var_dump.rb` に以下を記述：

```ruby
# config/initializers/setup_ruby_var_dump.rb
require 'ruby_var_dump'
Object.include RubyVarDump
```

この設定により、Rubyの `Object` クラスに RubyVarDump モジュールがインクルードされ、アプリケーション全体で `vdump` メソッドが利用可能になります。

### 手順1 と 手順2 をワンライナーで実行するには以下を実行して下さい。

```bash
echo -e "# config/initializers/setup_ruby_var_dump.rb\nrequire 'ruby_var_dump'\nObject.include RubyVarDump" > config/initializers/setup_ruby_var_dump.rb
```

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
