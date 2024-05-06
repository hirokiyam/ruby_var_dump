# frozen_string_literal: true

require 'rspec'
require 'stringio'
require_relative '../lib/ruby_var_dump'

RSpec.describe RubyVarDump do
  describe '.dump' do
    # 標準出力をキャプチャするためのヘルパーメソッド
    def capture_output
      original_stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end

    it "has a version number" do
      expect(RubyVarDump::VERSION).not_to be nil
    end

    context 'with simple objects' do
      it 'dumps strings' do
        output = capture_output { RubyVarDump.dump("hello") }
        expect(output).to eq("\"hello\"\n")
      end

      it 'dumps numbers' do
        output = capture_output { RubyVarDump.dump(123) }
        expect(output).to eq("123\n")
      end
    end

    context 'with arrays' do
      it 'dumps empty arrays' do
        output = capture_output { RubyVarDump.dump([]) }
        expect(output).to eq("[]\n")
      end

      it 'dumps non-empty arrays' do
        output = capture_output { RubyVarDump.dump([1, "hello", [1, 2]]) }
        expect(output).to eq("[\n  1,\n  \"hello\",\n  [\n    1,\n    2\n  ]\n]\n")
      end
    end

    context 'with hashes' do
      it 'dumps empty hashes' do
        output = capture_output { RubyVarDump.dump({}) }
        expect(output).to eq("{}\n")
      end

      it 'dumps non-empty hashes' do
        output = capture_output { RubyVarDump.dump({key: "value", another_key: 123}) }
        expect(output).to eq("{\n  :key => \"value\",\n  :another_key => 123\n}\n")
      end
    end

    context 'with ActiveRecord::Relation' do
      it 'dumps ActiveRecord::Relation objects correctly' do
        # ActiveRecord::Relation を模倣するダミークラス
        class DummyRelation < Array; end
        relation = DummyRelation.new([{id: 1, name: 'Alice'}, {id: 2, name: 'Bob'}])

        output = capture_output { RubyVarDump.dump(relation) }
        expected_output = "[\n  {\n    :id => 1,\n    :name => \"Alice\"\n  },\n  {\n    :id => 2,\n    :name => \"Bob\"\n  }\n]\n"
        expect(output).to eq(expected_output)
      end
    end

    context 'with objects that have an attributes method' do
      it 'dumps objects with attributes method correctly' do
        # attributes メソッドを持つダミーオブジェクト
        dummy_object = double("Model", attributes: {id: 1, name: 'Alice'})

        output = capture_output { RubyVarDump.dump(dummy_object) }
        expected_output = "{\n  :id => 1,\n  :name => \"Alice\"\n}\n"
        expect(output).to eq(expected_output)
      end
    end
  end
end

# ObjectクラスにRubyVarDumpモジュールのメソッドを追加
Object.include RubyVarDump

# bundle exec rspec spec/ruby_var_dump_spec.rb