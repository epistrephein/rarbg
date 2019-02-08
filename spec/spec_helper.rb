# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'rarbg'
require 'vcr'
require 'webmock/rspec'

RSpec.configure do |config|
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

VCR.configure do |config|
  config.cassette_library_dir     = 'spec/vcr/rarbg'
  config.default_cassette_options = { match_requests_on: [:query] }
  config.hook_into :webmock
end
