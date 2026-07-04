# frozen_string_literal: true
desc 'Run all bacon specs with pretty output'
task :bacon do
  require 'open3'

  specs = PROJECT_SPECS

  some_failed = false
  specs_size = specs.size
  len = specs.map(&:size).max
  totals = [0, 0, 0, 0]

  red = "\e[31m%s\e[0m"
  yellow = "\e[33m%s\e[0m"
  green = "\e[32m%s\e[0m"
  left_format = "%4d/%d: %-#{len + 11}s"
  spec_format = '%d specifications (%d requirements), %d failures, %d errors'
  summary_re = /(\d+) specifications \((\d+) requirements\), (\d+) failures, (\d+) errors/

  specs.each_with_index do |spec, idx|
    print(left_format % [idx + 1, specs_size, spec])

    Open3.popen3(FileUtils::RUBY, spec) do |_sin, sout, serr|
      out = sout.read.strip
      err = serr.read.strip

      # this is conventional, see spec/innate/state/fiber.rb for usage
      if out =~ /^Bacon::Error: (needed .*)/
        puts(yellow % ('%6s %s' % ['', Regexp.last_match(1)]))
      else
        match = out.match(summary_re)
        total = match&.captures&.map(&:to_i)

        if total
          totals = totals.zip(total).map { |a, b| a + b }
          tests, _, failures, errors = total

          if tests > 0 && failures + errors == 0
            puts((green % '%6d passed') % tests)
          else
            some_failed = true
            puts(red % '       failed')
            puts out unless out.empty?
            puts err unless err.empty?
          end
        else
          some_failed = true
          puts(red % '       failed')
          puts out unless out.empty?
          puts err unless err.empty?
        end
      end
    end
  end

  total_color = some_failed ? red : green
  puts(total_color % (spec_format % totals))
  exit 1 if some_failed
end
