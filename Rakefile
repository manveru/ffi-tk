# frozen_string_literal: true
require 'rake'
require 'rake/clean'
require 'time'
require 'date'

PROJECT_SPECS = FileList['spec/ffi-tk/**/*.rb']
PROJECT_MODULE = 'FFI::Tk'
PROJECT_README = 'README.md'
PROJECT_VERSION = (ENV['VERSION'] || Date.today.strftime('%Y.%m.%d')).dup

DEPENDENCIES = {
  'ffi' => { version: '~> 1.9' }
}.freeze

DEVELOPMENT_DEPENDENCIES = {
  'bacon' => { version: '~> 1.2' }
}.freeze

GEMSPEC = Gem::Specification.new do |s|
  s.name         = 'ffi-tk'
  s.author       = "Michael 'manveru' Fellinger"
  s.summary      = 'Pure Ruby FFI wrapper for the Tk GUI toolkit.'
  s.description  = 'Comfortably talk with Tcl/Tk using FFI.'
  s.email        = 'm.fellinger@gmail.com'
  s.licenses     = ['MIT']
  s.homepage     = 'http://github.com/manveru/ffi-tk'
  s.platform     = Gem::Platform::RUBY
  s.version      = PROJECT_VERSION
  s.files        = `git ls-files`.split("\n").sort
  s.has_rdoc     = true
  s.require_path = 'lib'
  s.required_rubygems_version = '>= 1.3.3'
end

DEPENDENCIES.each do |name, options|
  GEMSPEC.add_dependency(name, options[:version])
end

DEVELOPMENT_DEPENDENCIES.each do |name, options|
  GEMSPEC.add_development_dependency(name, options[:version])
end

Dir['tasks/*.rake'].each { |f| import(f) }

task default: [:bacon]

CLEAN.include('')
