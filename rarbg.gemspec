Gem::Specification.new do |s|
  s.name          = 'rarbg'
  s.version       = '0.1.4'
  s.date          = '2017-12-22'
  s.summary       = 'Ruby wrapper for RARBG torrentapi'
  s.description   = 'A ruby wrapper for RARBG torrentapi.'
  s.authors       = ['Tommaso Barbato']
  s.email         = 'epistrephein@gmail.com'
  s.files         = ['lib/rarbg.rb']
  s.homepage      = 'https://github.com/epistrephein/rarbg'
  s.license       = 'MIT'
  s.require_paths = ['lib']
  s.add_dependency 'faraday', '~> 0.10'
  s.add_dependency 'faraday_middleware', '~> 0.10'
end
