# frozen_string_literal: true

require File.expand_path('../lib/procto/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "procto_coverhound"
  gem.version = Procto::VERSION.dup
  gem.authors = [
    'Martin Gamsjaeger (snusnu)',
    'Nathan Seither (Supernats)',
  ]
  gem.email = 'eng-admin@coverhound.com'
  gem.description = <<~DESCRIPTION
    Turns your object into a method object.
  DESCRIPTION
  gem.summary = <<~SUMMARY
    Defines Foo.call(*args) which invokes Foo.new(*args).call.
    You can also define a Foo.bar(*args) which invokes Foo.new(*args).bar.
  SUMMARY
  gem.homepage = 'https://github.com/coverhound/procto'
  gem.required_ruby_version = ['>= 3.0', '< 4.1']
  gem.require_paths = ['lib']
  gem.files = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  gem.extra_rdoc_files = %w[LICENSE README.md]
  gem.license = 'MIT'
end
