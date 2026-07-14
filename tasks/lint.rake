# frozen_string_literal: true

desc 'Lint/format check (rubocop + nix) via treefmt; fails on any offense'
task :lint do
  # rubocop is deliberately kept out of the ruby-4.0 gem env (see flake.nix);
  # treefmt is the canonical way to reach it. --fail-on-change turns the
  # formatters into a gate: a rubocop offense (or an unformatted file) makes
  # treefmt exit non-zero. rubocop runs check-only here (no autocorrect), so a
  # failing `rake lint` reports the offenses without mutating your Ruby.
  #
  # with_unbundled_env is essential: rake is launched through a bundler wrapper
  # that exports RUBYOPT=-rbundler/setup and BUNDLE_GEMFILE into the environment.
  # Inherited by treefmt's ruby-3.4 rubocop, those make its ruby auto-load
  # bundler against our ruby-4.0 Gemfile.lock and crash on the native-extension
  # gems (ffi, io-console) it cannot materialize. Stripping them restores the
  # pristine environment rubocop expects.
  require 'bundler'
  Bundler.with_unbundled_env do
    sh 'treefmt --fail-on-change --no-cache'
  end
end

desc 'Run the linter and then the full spec suite'
task check: %i[lint bacon]
