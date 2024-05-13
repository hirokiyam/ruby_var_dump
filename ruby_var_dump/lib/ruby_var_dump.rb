# frozen_string_literal: true

require_relative "ruby_var_dump/version"

module RubyVarDump
  class Error < StandardError; end

  def dump(obj, klass=obj.class, level = 0, is_value = false, dumped_objects = [], is_first=true)
    indent = ' ' * level * 2

    if dumped_objects.include?(obj.object_id)
      puts "#{indent}<Recursive reference: #{obj.class}:#{obj.object_id}>"
      return
    end
  
    dumped_objects << obj.object_id

    if obj.is_a?(Array)
      print "#{is_value ? '' : indent}" + "["
      if obj.empty?
        print "]"
        print "\n" if level == 0 # メソッドの出力の最後に改行を追加
      else
        print "\n"
        obj.each_with_index do |item, index|
          dump(item, item.class, level + 1, false, dumped_objects, false)
          print "," unless index == obj.size - 1
          print "\n"
        end
        print "#{indent}]"
        print "\n" if level == 0 # メソッドの出力の最後に改行を追加
      end
    elsif obj.is_a?(Hash)
      print "#{is_value ? '' : indent}" + "{"
      if obj.empty?
        print "}"
        print "\n" if level == 0 # メソッドの出力の最後に改行を追加
      else
        print "\n"
        obj.each_with_index do |(key, value), index|
          # キーにインデントを適用し、値にはインデントを適用しない
          print "#{indent}  #{key.inspect.chomp} => "
          if value.is_a?(Hash) || value.is_a?(Array)
            dump(value, value.class, level + 1, true, dumped_objects, false)  # ハッシュのバリューの場合には is_value を true に設定
          else
            print value.inspect  # プリミティブな値の場合は現在のレベルで出力
          end
          print "," unless index == obj.size - 1
          print "\n"
        end
        print "#{indent}}"
        print "\n" if level == 0 # メソッドの出力の最後に改行を追加
      end
    elsif defined?(ActiveRecord::Base) && obj.is_a?(ActiveRecord::Base)
      # ActiveRecordオブジェクトの場合
      print "\n" unless is_first  # 最初のレコード以外の場合に改行を入れる
      print "#{indent}#{obj.class}:#{obj.object_id}\n"
      print "#{indent}{\n"
      obj.attributes.each do |attr_name, attr_value|
        print "#{indent}  #{attr_name}: #{attr_value.inspect},\n"
      end
      # リレーションも再帰的にダンプ
      obj.class.reflect_on_all_associations.each do |association|
        associated_value = obj.send(association.name)
        print "#{indent}  << #{association.name} >> (association):"
        if associated_value.respond_to?(:each) # アソシエーションがコレクションの場合
          next if associated_value.nil? || associated_value.empty?
          print("\n#{indent}  [\n")
          associated_value.each do |item|
            next if dumped_objects.include?(item.object_id)
    
            # CollectionProxy の内容をダンプ 
            print("#{indent}    #{association.name}: #{item.class}:#{item.object_id}\n")
            print("#{indent}    {\n")
            item.attributes.each do |attr_name, attr_value|
              print("#{indent}      #{attr_name}: #{attr_value.inspect}\n")
            end
    
            print("#{indent}    }\n")
          end
          print("#{indent}  ]\n")
        end
      end
      print "#{indent}}\n"
      print "\n" if level == 0
    elsif defined?(ActiveRecord::Relation) && obj.is_a?(ActiveRecord::Relation)
      # ActiveRecord::Relation の場合
      print "#{indent}#{obj.class}:#{obj.object_id}\n"
      print "#{indent}[\n"
      obj.each_with_index do |item, index|
        dump(item, item.class, level + 1, true, dumped_objects, index == 0) # 各オブジェクトに対して再帰的にdumpを呼び出す
      end
      print "#{indent}]\n"
      print "\n" if level == 0 # メソッドの出力の最後に改行を追加
    elsif obj.respond_to?(:attributes)
      dump(obj.attributes, obj.class, level, false, dumped_objects, false)
    else
      print indent + obj.inspect.chomp
      print "\n"  if level == 0 # メソッドの出力の最後に改行を追加
    end
  end
end
# gem build ruby_var_dump.gemspec
