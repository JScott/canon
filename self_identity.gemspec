Gem::Specification.new do |gem|
  gem.name        = 'self_identity'
  gem.version     = '0.0.1'
  gem.licenses    = 'MIT'
  gem.authors     = ['Justin Scott','Chris Olstrom']
  gem.email       = 'jvscott@gmail.com'
  gem.homepage    = 'http://www.github.com/colstrom/self_identity/'
  gem.summary     = 'Self Identity'
  gem.description = 'Allowing programs to understand their own functionality.'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- kintama/**/*`.split("\n")

  gem.add_runtime_dependency 'moneta'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'kintama'
  gem.add_development_dependency 'terminaltable'
end
