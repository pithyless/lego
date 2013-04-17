#!/usr/bin/env rake

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.libs.push "spec"
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = false
end

task :default => 'test'
