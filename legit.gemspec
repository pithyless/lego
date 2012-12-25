# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Norbert Wojtowicz"]
  gem.email         = ["wojtowicz.norbert@gmail.com"]
  gem.description   = "Making sure your forms are legit since 2012"
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/pithyless/legit"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "legit"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
