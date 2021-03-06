# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rarbg/version'

Gem::Specification.new do |spec|
  spec.name        = 'rarbg'
  spec.version     = RARBG::VERSION
  spec.author      = 'Tommaso Barbato'
  spec.email       = 'epistrephein@gmail.com'
  spec.summary     = 'RARBG API Ruby client.'
  spec.description = 'Ruby client for the RARBG Torrent API.'
  spec.homepage    = 'https://github.com/epistrephein/rarbg'
  spec.license     = 'MIT'

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/epistrephein/rarbg/issues',
    'changelog_uri'     => 'https://github.com/epistrephein/rarbg/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://epistrephein.github.io/rarbg',
    'homepage_uri'      => 'https://github.com/epistrephein/rarbg',
    'source_code_uri'   => 'https://github.com/epistrephein/rarbg'
  }

  spec.files            = Dir['lib/**/*']
  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE']
  spec.require_path     = 'lib'

  spec.required_ruby_version = '>= 2.3'

  spec.add_runtime_dependency 'faraday', '~> 1.0'

  spec.add_development_dependency 'bundler', '>= 1.15', '< 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '>= 12.0', '< 14.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 0.80.0'
  spec.add_development_dependency 'simplecov', '~> 0.13', '< 0.18'
  spec.add_development_dependency 'webmock', '~> 3.0'
  spec.add_development_dependency 'yard', '~> 0.9'
end
