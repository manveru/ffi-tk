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
  # A curated manifest, not `git ls-files`: the git listing sweeps in dev/CI
  # infra (flake.nix, gemset.nix, .rubocop.yml, tasks/, spec/, Gemfile, ...)
  # that has no place in a published gem, and it silently yields an empty list
  # when building from a tarball with no .git. These globs ship only what a
  # consumer needs: the library, the rwish executable, licenses, and top-level
  # docs. `rake gemspec` freezes the expanded list into ffi-tk.gemspec.
  s.files        = Dir[
    'lib/**/*.rb',
    'bin/*',
    'doc/*',
    'README.md',
    'CHANGELOG',
    'AUTHORS',
    'TODO.md',
    'ffi-tk.gemspec'
  ].sort
  s.bindir       = 'bin'
  s.executables  = ['rwish']
  s.require_path = 'lib'
  s.required_ruby_version = '>= 4.0'
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

CLEAN.include('coverage')
