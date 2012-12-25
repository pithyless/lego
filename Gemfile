source 'https://rubygems.org'

# Specify your gem's dependencies in legit.gemspec
gemspec

group :development, :test do
  gem 'guard-rspec'
  gem 'fuubar'

  gem 'growl',      :require => RUBY_PLATFORM.include?('darwin') && 'growl'
  gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux')  && 'rb-inotify'
end
