# frozen_string_literal: true

require "ruby_var_dump"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    # 標準出力をキャプチャするヘルパーメソッド
    def capture_output
      original_stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end
  end

  # spec/support ディレクトリ内の全ファイルを読み込む
  # Dir[File.join(__dir__, 'support/**/*.rb')].each { |f| require f }
end

