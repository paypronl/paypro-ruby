# frozen_string_literal: true

require 'bundler/setup'
require 'webmock/rspec'
require 'timecop'

require 'debug'

require 'pay_pro'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Allow the filtering be specifying the focus
  config.filter_run_when_matching :focus

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    PayPro.api_key = 'pp_test'
  end

  config.after do
    PayPro.api_key = nil
  end
end
