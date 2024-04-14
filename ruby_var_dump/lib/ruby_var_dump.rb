# frozen_string_literal: true

require_relative "ruby_var_dump/version"

module RubyVarDump
  class Error < StandardError; end
  # Your code goes here...

  def dump(obj, level = 0, is_value = false)
    indent = ' ' * level * 2
    if obj.is_a?(Array)
      print "#{is_value ? '' : indent}" + "["
      if obj.empty?
        print "]"
      else
        print "\n"
        obj.each_with_index do |item, index|
          dump(item, level + 1, false)
          print "," unless index == obj.size - 1
          print "\n"
        end
        print "#{indent}]"
      end
    elsif obj.is_a?(Hash)
      print "#{is_value ? '' : indent}" + "{"
      if obj.empty?
        print "}"
      else
        print "\n"
        obj.each_with_index do |(key, value), index|
          # キーにインデントを適用し、値にはインデントを適用しない
          print "#{indent}  #{key.inspect.chomp} => "
          if value.is_a?(Hash) || value.is_a?(Array)
            dump(value, level + 1, true)  # ハッシュのバリューの場合には is_value を true に設定
          else
            print value.inspect  # プリミティブな値の場合は現在のレベルで出力
          end
          print "," unless index == obj.size - 1
          print "\n"
        end
        print "#{indent}}"
      end
    elsif defined?(ActiveRecord::Relation) && obj.is_a?(ActiveRecord::Relation)
      obj.each_with_index do |record, index|
        dump(record, level, false)
        if index < obj.size - 1 # 要素が続く場合
          print ",\n"
        else
          print "\n" # レコードの最後の場合は改行のみ
        end
      end
    elsif obj.respond_to?(:attributes)
      dump(obj.attributes, level, false)
    else
      print indent + obj.inspect.chomp
    end
  end
end
