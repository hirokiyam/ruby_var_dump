# frozen_string_literal: true

require 'rspec'
require 'stringio'
require 'date'
require_relative '../lib/ruby_var_dump'

RSpec.describe RubyVarDump do
  describe '.vdump' do
    # 標準出力をキャプチャしてカラーコードを保持する
    def capture_output_with_color
      original_stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end

    # 標準出力をキャプチャしてカラーコードを除去する（値のみの検証用）
    def capture_output
      capture_output_with_color do
        yield
      end.gsub(/\e\[\d+(;\d+)*m/, '')
    end

    it "has a version number" do
      expect(RubyVarDump::VERSION).not_to be nil
    end

    context 'with simple objects' do
      context "when String" do
        it 'dumps strings correctly without color' do
          output = capture_output { RubyVarDump.vdump("hello") }
          expect(output).to eq("\"hello\"\n")
        end

        it 'dumps strings with correct color' do
          output = capture_output_with_color { RubyVarDump.vdump("hello") }
          expect(output).to include("\e[38;5;203m\"hello\"\e[0m\n")
        end
      end

      context "when Number" do
        it 'dumps numbers correctly without color' do
          output = capture_output { RubyVarDump.vdump(123) }
          expect(output).to eq("123\n")
        end

        it 'dumps numbers with correct color' do
          output = capture_output_with_color { RubyVarDump.vdump(123) }
          expect(output).to include("\e[38;5;27m123\e[0m\n")
        end
      end

      context "when Date" do
        let(:date) { Date.new(2025, 12, 3) }
      
        it 'dumps date correctly without color' do
          output = capture_output { RubyVarDump.vdump(date) }
          expect(output).to eq(date.inspect + "\n")  # Date#inspectの出力に基づく
        end
      
        it 'dumps date with correct color' do
          output = capture_output_with_color { RubyVarDump.vdump(date) }
          expected_output = "\e[38;5;10m#{date.inspect}\e[0m\n"  # ANSIカラーコードを含む期待値
          expect(output).to include(expected_output)
        end
      end
    end

    context 'with arrays' do
      it 'dumps empty arrays' do
        output = capture_output { RubyVarDump.vdump([]) }
        expect(output).to eq("[]\n")
      end

      it 'dumps non-empty arrays' do
        output = capture_output { RubyVarDump.vdump([1, "hello", [1, 2]]) }
        expect(output).to eq("[\n  1,\n  \"hello\",\n  [\n    1,\n    2\n  ]\n]\n")
      end
    end

    context 'with hashes' do
      it 'dumps empty hashes' do
        output = capture_output { RubyVarDump.vdump({}) }
        expect(output).to eq("{}\n")
      end

      it 'dumps non-empty hashes' do
        output = capture_output { RubyVarDump.vdump({key: "value", another_key: 123}) }
        expect(output).to eq("{\n  :key => \"value\",\n  :another_key => 123\n}\n")
      end
    end

    context 'with ActiveRecord::Relation' do
      it 'dumps ActiveRecord::Relation objects correctly' do
        # ActiveRecord::Relation を模倣するダミークラス
        class DummyRelation < Array; end
        relation = DummyRelation.new([{id: 1, name: 'Alice'}, {id: 2, name: 'Bob'}])

        output = capture_output { RubyVarDump.vdump(relation) }
        expected_output = "[\n  {\n    :id => 1,\n    :name => \"Alice\"\n  },\n  {\n    :id => 2,\n    :name => \"Bob\"\n  }\n]\n"
        expect(output).to eq(expected_output)
      end
    end

    context 'with objects that have an attributes method' do
      it 'dumps objects with attributes method correctly' do
        # attributes メソッドを持つダミーオブジェクト
        dummy_object = double("Model", attributes: {id: 1, name: 'Alice'})

        output = capture_output { RubyVarDump.vdump(dummy_object) }
        expected_output = "{\n  :id => 1,\n  :name => \"Alice\"\n}\n"
        expect(output).to eq(expected_output)
      end
    end
  end
end

# ObjectクラスにRubyVarDumpモジュールのメソッドを追加
Object.include RubyVarDump

# bundle exec rspec spec/ruby_var_dump_spec.rb