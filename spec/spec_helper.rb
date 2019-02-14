# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'webmock/rspec'
require 'securerandom'
require 'rarbg'

require_relative 'stubs'

RSpec.configure do |config|
  # Attach WebMock and its stubbed requests.
  WebMock.disable_net_connect!(allow_localhost: true)
  config.include(Stubs)

  # Enable flags like --only-failures and --next-failure.
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`.
  config.disable_monkey_patching!

  # Enable temporarily focused examples and groups.
  config.filter_run_when_matching :focus

  # Use expect syntax.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Stub RATE_LIMIT to speed up tests.
  config.before(:example) do
    stub_const('RARBG::API::RATE_LIMIT', 0.1)
  end
end
