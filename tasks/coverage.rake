# frozen_string_literal: true

desc 'Run all specs under SimpleCov and report line coverage per file'
task :coverage do
  require 'open3'
  require_relative 'support/headless_display'

  ENV['COVERAGE'] = '1'

  # Start from a clean slate. SimpleCov merges each process's result into
  # coverage/.resultset.json and keeps prior runs' entries for merge_timeout
  # (24h, set in spec/helper.rb). Left uncleared, the file accumulates hundreds
  # of command_names and grows to ~100MB, and every one of the ~72 spec
  # processes re-parses and rewrites it at exit (~1.3s each, ~95s total waste).
  require 'fileutils'
  FileUtils.rm_rf('coverage')

  specs = PROJECT_SPECS
  failed = []

  HeadlessDisplay.with_display do |env|
    specs.each_with_index do |spec, idx|
      print(format("%4d/%d: %s\n", idx + 1, specs.size, spec))
      out, status = Open3.capture2e(env, FileUtils::RUBY, spec)
      summary = out[/(\d+) specifications .*/]
      failed << spec unless status.success? && summary && out !~ / [1-9]\d* (failures|errors)/
    end
  end

  # Merge every per-process result into one union and report.
  require 'simplecov'
  SimpleCov.track_files 'lib/**/*.rb'
  SimpleCov.add_filter '/spec/'
  result = SimpleCov::ResultMerger.merged_result

  rows = result.files
                .select { |f| f.filename.include?('/lib/') }
                .map { |f| [f.filename.sub("#{Dir.pwd}/", ''), f.covered_percent, f.lines_of_code] }
                .sort_by { |_rel, pct, _loc| pct }

  puts
  puts format('%-52<file>s %7<cov>s %6<loc>s', file: 'FILE', cov: 'COV%', loc: 'LOC')
  puts('-' * 68)
  rows.each { |rel, pct, loc| puts format('%-52<f>s %6.1<p>f%% %6<l>d', f: rel, p: pct, l: loc) }
  puts('-' * 68)
  puts format('overall line coverage: %.2<p>f%%  (%<n>d lib files, %<z>d at 0%%)',
              p: result.covered_percent, n: rows.size, z: rows.count { |_r, pct, _l| pct.zero? })

  SimpleCov::Formatter::HTMLFormatter.new.format(result)
  puts "html report: coverage/index.html"

  unless failed.empty?
    warn "\n#{failed.size} spec file(s) failed under coverage run:"
    failed.each { |f| warn "  #{f}" }
  end
end
