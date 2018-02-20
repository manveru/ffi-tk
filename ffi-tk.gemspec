# -*- encoding: utf-8 -*-
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'ffi-tk'
  s.version = '2017.02.20'

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.3') if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael 'manveru' Fellinger"]
  s.date = '2017-02-20'
  s.description = 'Pure Ruby FFI wrapper for the Tk GUI toolkit.'
  s.email = 'm.fellinger@gmail.com'
  s.files = Dir['**/*']
  s.homepage = 'http://github.com/manveru/ffi-tk'
  s.require_paths = ['lib']
  s.rubygems_version = '1.3.7'
  s.summary = 'Pure Ruby FFI wrapper for the Tk GUI toolkit.'

  s.add_runtime_dependency('ffi', ['~> 1.9'])
  s.add_development_dependency('bacon', ['~> 1.2'])
end
