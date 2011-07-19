# -*- encoding: utf-8 -*-
require './lib/set_man/version.rb'

Gem::Specification.new do |s|
	s.name 				= "set_man"
	s.version 		= SetMan::Version::STRING
	s.platform 		= Gem::Platform::RUBY
	s.authors			= ["plutalov_alexey"]
	s.email				=	["demiazz.py@gmail.com"]
	s.homepage		= "https://github.com/demiazz/set_man"
	s.summary			=	%q{Simple settings manager for your application.}
	s.description	=	%q{Simple settings manager for your application.}

	s.files				= `git ls-files`.split("\n")
	s.test_files  = `git ls-files -- test/*`.split("\n")
	s.require_paths = ["lib"]
end

