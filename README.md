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

To make RubyVarDump methods accessible in your class, add `include RubyVarDump` at the top of your class definition, right after the class declaration. This will mix in the RubyVarDump module methods as instance methods in your class.

```ruby
include RubyVarDump
```

### Example Setup

Here's a simple example to demonstrate how to include and use the RubyVarDump in a Ruby class:

```ruby
require 'ruby_var_dump'

class ExampleClass
  include RubyVarDump # This line mixes in RubyVarDump methods

  def demonstrate_dump
    # Define some example data
    my_hash = {key1: "value1", key2: 123}
    my_array = [1, 2, 3, {nested_key: "nested_value"}]

    # Use the dump method to output the structure of these objects
    dump my_hash
    dump my_array
  end
end
```

Output:

```
{
  :key1 => "value1",
  :key2 => 123
}=> nil

[
  1,
  2,
  3,
  {
    :nested_key => "nested_value"
  }
]=> nil
```