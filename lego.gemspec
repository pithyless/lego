# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Norbert Wojtowicz"]
  gem.email         = ["wojtowicz.norbert@gmail.com"]
  gem.description   = "Data building blocks for you app."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/pithyless/lego"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lego"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.5'

  gem.add_dependency 'activesupport', '~> 3.2.0'
  gem.add_dependency 'equalizer', '~> 0.0.5'
  gem.add_dependency 'abstract_type', '~> 0.0.4'
  gem.add_dependency 'to_h', '~> 0.0.2'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest', '~> 4.7.1'
end
