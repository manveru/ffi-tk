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

  # Union every per-process raw Coverage dump, then do ONE SimpleCov pass:
  # track_files fills in never-loaded lib files (0%), add_filter drops specs.
  require 'simplecov'
  SimpleCov.configure do
    track_files 'lib/**/*.rb'
    add_filter '/spec/'
    enable_coverage :line
  end

  merged = {}
  Dir['coverage/raw/*.dump'].each do |dump|
    # Coverage's own raw dumps, written by our spec processes above; trusted input.
    Marshal.load(File.binread(dump)).each do |path, cov| # rubocop:disable Security/MarshalLoad
      lines = cov[:lines] || cov['lines']
      acc = (merged[path] ||= [])
      lines.each_with_index do |hit, i|
        next if hit.nil?

        acc[i] = [acc[i] || 0, hit].max
      end
    end
  end

  coverage = merged.transform_values { |lines| { 'lines' => lines } }
  coverage = SimpleCov.send(:add_not_loaded_files, coverage)
  result = SimpleCov::Result.new(coverage)

  rows = result.files
               .select { |f| f.filename.include?('/lib/') }
               .map { |f| [f.filename.sub("#{Dir.pwd}/", ''), f.covered_percent, f.lines_of_code] }
               .sort_by { |_rel, pct, _loc| pct }

  puts
  header_fmt = '%-52s %7s %6s'
  puts format(header_fmt, 'FILE', 'COV%', 'LOC')
  puts('-' * 68)
  rows.each { |rel, pct, loc| puts format('%-52s %6.1f%% %6d', rel, pct, loc) }
  puts('-' * 68)
  puts format('overall line coverage: %.2f%%  (%d lib files, %d at 0%%)',
              result.covered_percent, rows.size, rows.count { |_r, pct, _l| pct.zero? })

  SimpleCov::Formatter::HTMLFormatter.new.format(result)
  puts 'html report: coverage/index.html'

  unless failed.empty?
    warn "\n#{failed.size} spec file(s) failed under coverage run:"
    failed.each { |f| warn "  #{f}" }
  end
end
