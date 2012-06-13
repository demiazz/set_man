# coding: utf-8

require File.expand_path('../lib/set_man/version', __FILE__)

Gem::Specification.new do |s|
  s.platform              = Gem::Platform::RUBY
  s.name                  = 'set_man'
  s.version               = SetMan::VERSION
  s.summary               = 'Simple settings manager for your application.'
  s.description           = 'Simple settings manager for your application.'

  s.required_ruby_version = '>= 1.9.3'
  s.license               = 'MIT'

  s.author                = 'Alexey Plutalov'
  s.email                 = 'demiazz.py@gmail.com'
  s.homepage              = 'https://github.com/demiazz/set_man'

  s.files                 = Dir['LICENSE', 'README.md', 'lib/*/**']
  s.require_path          = 'lib'

  s.add_dependency 'activesupport', '~> 3.2.5'

  s.add_development_dependency 'rspec', '~> 2.10'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'pry'
end
