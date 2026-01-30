# frozen_string_literal: true

require 'rake/testtask'
require 'bundler'

# Set up gem tasks with explicit gemspec name
Bundler::GemHelper.install_tasks(name: 'procto_coverhound')

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test
task ci: :test
