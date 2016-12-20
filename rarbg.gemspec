Gem::Specification.new do |s|
  s.name          = 'rarbg'
  s.version       = '0.1.0'
  s.date          = '2016-12-20'
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
