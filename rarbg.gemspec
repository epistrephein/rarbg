# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rarbg/version'

Gem::Specification.new do |spec|
  spec.name          = 'rarbg'
  spec.version       = RARBG::VERSION
  spec.author        = 'Tommaso Barbato'
  spec.email         = 'epistrephein@gmail.com'

  spec.summary       = 'RARBG Ruby client.'
  spec.description   = 'Ruby wrapper for RARBG Torrent API.'
  spec.homepage      = 'https://github.com/epistrephein/rarbg'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_path  = 'lib'

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/epistrephein/rarbg/issues',
    'changelog_uri'     => 'https://github.com/epistrephein/rarbg/blob/master/CHANGELOG.md',
    'documentation_uri' => "http://www.rubydoc.info/gems/rarbg/#{RARBG::VERSION}",
    'homepage_uri'      => 'https://github.com/epistrephein/rarbg',
    'source_code_uri'   => 'https://github.com/epistrephein/rarbg'
  }

  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'faraday', '~> 0.10'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.10'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0'
  spec.add_development_dependency 'webmock', '~> 3.3'
  spec.add_development_dependency 'yard', '~> 0.9'
end
