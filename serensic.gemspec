require File.expand_path('lib/serensic/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name        = 'serensic'
  s.version     = Serensic::VERSION
  s.license     = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.date        = '2016-12-13'
  s.summary     = 'This is the Ruby client library for Serensic \'s API.'
  s.description = 'Serensic Client Library for Ruby'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(LICENSE.txt README.md serensic.gemspec)
  s.authors     = ['Marks Francis']
  s.email       = 'marks@serensic.com'
  s.homepage    = 'https://github.com/pesaply/serensic-ruby'
  s.required_ruby_version = '>= 2.2.6'
  s.add_development_dependency('rake', '~> 11.0')
  s.add_development_dependency('minitest', '~> 5.0')
  s.add_development_dependency "rspec"

  if RUBY_VERSION == '2.2.6'
    s.add_development_dependency('addressable', '< 2.5.0')
    s.add_development_dependency('webmock', '~> 1.0')
  else
    s.add_development_dependency('webmock', '~> 2.0')
  end

  s.require_path = 'lib'
end
