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
      raw_output = capture_output_with_color do
        yield
      end.gsub(/\e\[\d+(;\d+)*m/, '')

      # デバッグヘッダーを除去して実際の内容のみを抽出
      extract_content_from_debug_output(raw_output)
    end

    # デバッグ出力から実際の内容を抽出するヘルパーメソッド
    def extract_content_from_debug_output(output)
      lines = output.split("\n")

      # 開始行と終了行のインデックスを見つける
      start_index = lines.find_index { |line| line.include?("Start Output (ruby_var_dump)") }
      end_index = lines.find_index { |line| line.include?("End Output (ruby_var_dump)") }

      return output if start_index.nil? || end_index.nil?

      # デバッグヘッダーを除いた内容を抽出
      # 開始ヘッダーの1行後(3行目)から終了ヘッダーまで（終了ヘッダー行は含まない）
      content_lines = lines[(start_index + 1)...end_index]
      content_lines.join("\n") + "\n"
    end

    it "has a version number" do
      expect(RubyVarDump::VERSION).not_to be nil
    end

    context 'debug template headers and footers' do
      it 'displays correct start header and end footer with timestamp' do
        output = capture_output_with_color { RubyVarDump.vdump("test") }

        # 開始ヘッダーの確認
        expect(output).to include("Start Output (ruby_var_dump)")
        expect(output).to match(/Start Output \(ruby_var_dump\) \| \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)

        # 終了フッターの確認
        expect(output).to include("End Output (ruby_var_dump)")
        expect(output).to match(/End Output \(ruby_var_dump\) \| \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)

        # 区切り線（80文字の=）の確認
        expect(output).to include("=" * 80)
      end

      it 'displays header and footer with correct colors' do
        output = capture_output_with_color { RubyVarDump.vdump("test") }

        # 開始ヘッダーは黄色（YELLOW_COLOR = \e[33m）
        expect(output).to match(/\e\[33m=+.*Start Output.*=+\e\[0m/)

        # 終了フッターは明るい緑色（BRIGHT_GREEN_COLOR = \e[32m）
        expect(output).to match(/\e\[32m=+.*End Output.*=+\e\[0m/)
      end

      it 'displays exactly 2 header lines at start and 2 footer lines at end' do
        output = capture_output_with_color { RubyVarDump.vdump("test") }
        lines = output.split("\n")

        # 開始部分：2行の区切り線とヘッダー
        expect(lines[0]).to match(/\e\[33m=+\e\[0m$/)  # 1行目：区切り線（カラーコード付き）
        expect(lines[1]).to include("Start Output (ruby_var_dump)")  # 2行目：開始ヘッダー

        # 終了部分：2行の区切り線とフッター
        expect(lines[-2]).to include("End Output (ruby_var_dump)")  # 最後から2行目：終了フッター
        expect(lines[-1]).to match(/\e\[32m=+\e\[0m$/)  # 最後の行：区切り線（カラーコード付き）

        # 区切り線が正確に80文字であることも確認（カラーコード除去後）
        clean_first_line = lines[0].gsub(/\e\[\d+(;\d+)*m/, '')
        clean_last_line = lines[-1].gsub(/\e\[\d+(;\d+)*m/, '')
        expect(clean_first_line.length).to eq(80)
        expect(clean_last_line.length).to eq(80)
      end
    end

    context 'with simple objects' do
      context "when String" do
        it 'dumps strings correctly without color' do
          output = capture_output { RubyVarDump.vdump("hello") }
          expect(output).to eq("\"hello\"\n")
        end

        it 'dumps strings with correct color' do
          output = capture_output_with_color { RubyVarDump.vdump("hello") }
          # デバッグヘッダーを含む出力から実際の内容部分をチェック
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
          # デバッグヘッダーを含む出力から実際の内容部分をチェック
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
          # デバッグヘッダーを含む出力から実際の内容部分をチェック
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

  describe '.assoc (association output toggle)' do
    # 他のテストに影響しないよう、テスト後に元の値へ戻す
    around do |example|
      saved = RubyVarDump.assoc
      example.run
      RubyVarDump.assoc = saved
    end

    it 'defaults to ON (shows associations)' do
      expect(RubyVarDump.show_associations?).to be(true)
    end

    it 'hides associations when set to 0' do
      RubyVarDump.assoc = 0
      expect(RubyVarDump.show_associations?).to be(false)
    end

    it 'shows associations again when set to 1' do
      RubyVarDump.assoc = 1
      expect(RubyVarDump.show_associations?).to be(true)
    end

    it 'also treats false as OFF' do
      RubyVarDump.assoc = false
      expect(RubyVarDump.show_associations?).to be(false)
    end
  end
end

# bundle exec rspec spec/ruby_var_dump_spec.rb