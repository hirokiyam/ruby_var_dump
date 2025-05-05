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
