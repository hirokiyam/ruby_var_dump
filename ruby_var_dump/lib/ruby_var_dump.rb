# frozen_string_literal: true

require_relative "ruby_var_dump/version"

module RubyVarDump
  class Error < StandardError; end

  # カラーコードの定義
  RED_COLOR = "\e[38;5;196m"    # 赤色
  LIGHT_RED_COLOR = "\e[38;5;203m" # サーモンピンク
  BLUE_COLOR = "\e[38;5;27m"    # 青色
  GREEN_COLOR = "\e[38;5;2m"   # 緑色
  LIGHT_GREEN_COLOR = "\e[38;5;10m" # 薄緑色
  # LIGHT_BLUE = "\e[38;5;45m"    # 水色
  ORANGE_COLOR = "\e[38;5;214m" # オレンジ色
  RESET_COLOR = "\e[0m"         # 色リセット

  def vdump(obj, level = 0, is_value = false, dumped_objects = [], is_first=true)
    indent = ' ' * level * 2

    if (defined?(ActiveRecord::Base) && obj.is_a?(ActiveRecord::Base)) || (defined?(ActiveRecord::Relation) && obj.is_a?(ActiveRecord::Relation))
      if dumped_objects.any? { |dumped_obj| dumped_obj.object_id == obj.object_id && dumped_obj.class == obj.class }
        puts "#{indent}<Recursive reference: #{obj.class}:#{obj.object_id}>"
        return
      else
        dumped_objects << obj
      end
    end

    if obj.is_a?(Array)
      print "#{is_value ? '' : indent}" + "["
      if obj.empty?
        print "]"
        print "\n" if level == 0 # メソッドの出力の最後に改行を追加
      else
        print "\n"
        obj.each_with_index do |item, index|
          vdump(item, level + 1, false, dumped_objects, false)
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
            vdump(value, level + 1, true, dumped_objects, false)  # ハッシュのバリューの場合には is_value を true に設定
          else
            # プリミティブな値の場合は現在のレベルで出力
            print colorize_by_type(value)
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
      print "#{indent}#{GREEN_COLOR}#{obj.class}:#{obj.object_id}#{RESET_COLOR}\n"
      print "#{indent}{\n"
      obj.attributes.each do |attr_name, attr_value|
        print "#{indent}  #{attr_name}: #{colorize_by_type(attr_value)},\n"
      end
      # リレーションも再帰的にダンプ
      obj.class.reflect_on_all_associations.each do |association|
        next if association.macro.nil? # アソシエーションが存在しない場合はスキップ

        associated_value = obj.send(association.name)
        if associated_value.respond_to?(:each) # アソシエーションがコレクションの場合
          next if associated_value.empty?

          associated_value.each do |item|
            next if dumped_objects.any? { |dumped_obj| dumped_obj.object_id == item.object_id && dumped_obj.class == item.class }

            # CollectionProxy の内容（アソシエーション）をダンプ
            print("#{indent}  #{RED_COLOR}#{association.name} #{ORANGE_COLOR}(association)#{RESET_COLOR}: #{GREEN_COLOR}<< #{item.class}:#{item.object_id} >>#{RESET_COLOR}\n")
            print("#{indent}  {\n")
            item.attributes.each do |attr_name, attr_value|
              print("#{indent}    #{attr_name}: #{colorize_by_type(attr_value)}\n")
            end
    
            print("#{indent}  }\n") #ここまでアソシエーションの描画
          end
        end
      end
      print "#{indent}}\n"
    elsif defined?(ActiveRecord::Relation) && obj.is_a?(ActiveRecord::Relation)
      print "#{indent}#{obj.class}:#{obj.object_id}\n"
      print "#{indent}[\n"
      obj.each_with_index do |item, index|
        vdump(item, level + 1, false, dumped_objects, index == 0)
      end
      print "#{indent}]"
      print "\n" if level == 0 # メソッドの出力の最後に改行を追加
    elsif obj.respond_to?(:attributes)
      vdump(obj.attributes, level, false, dumped_objects, false)
    else
      print indent + colorize_by_type(obj) # プリミティブな値の場合を出力
      print "\n"  if level == 0 # メソッドの出力の最後に改行を追加
    end
  end

  # エイリアスを設定。vdump メソッドの別名として vpp を定義
  alias vpp vdump

  private

  def colorize_by_type(obj)
    color = color_for(obj)
    "#{color}#{obj.inspect.chomp}#{RESET_COLOR}"
  end

  def color_for(obj)
    if obj.is_a?(String)
      LIGHT_RED_COLOR
    elsif obj.is_a?(Numeric)
      BLUE_COLOR
    elsif obj.is_a?(Date) || obj.is_a?(Time) || obj.is_a?(DateTime)
      LIGHT_GREEN_COLOR
    else
      ""
    end
  end
end
# gem build ruby_var_dump.gemspec
