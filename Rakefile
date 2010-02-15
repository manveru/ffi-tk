require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'time'
require 'date'

PROJECT_SPECS = FileList['spec/ffi-tk/**/*.rb']
PROJECT_MODULE = 'FFI::Tk'
PROJECT_README = 'README.md'
PROJECT_VERSION = ENV['VERSION'] || Date.today.strftime('%Y.%m.%d')

DEPENDENCIES = {
  'ffi' => {:version => '~> 0.6.0'},
}

DEVELOPMENT_DEPENDENCIES = {
  'bacon'     => {:version => '>= 1.1.0'},
}

GEMSPEC = Gem::Specification.new{|s|
  s.name         = 'ffi-tk'
  s.author       = "Michael 'manveru' Fellinger"
  s.summary      = "Pure Ruby FFI wrapper for the Tk GUI toolkit."
  s.description  = "Pure Ruby FFI wrapper for the Tk GUI toolkit."
  s.email        = 'm.fellinger@gmail.com'
  s.homepage     = 'http://github.com/manveru/ffi-tk'
  s.platform     = Gem::Platform::RUBY
  s.version      = PROJECT_VERSION
  s.files        = `git ls-files`.split("\n").sort
  s.has_rdoc     = true
  s.require_path = 'lib'
  s.required_rubygems_version = '>= 1.3.5'
}

DEPENDENCIES.each do |name, options|
  GEMSPEC.add_dependency(name, options[:version])
end

DEVELOPMENT_DEPENDENCIES.each do |name, options|
  GEMSPEC.add_development_dependency(name, options[:version])
end

Dir['tasks/*.rake'].each{|f| import(f) }

task :default => [:bacon]

CLEAN.include('')
