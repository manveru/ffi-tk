# frozen_string_literal: true

desc 'update version.rb'
task :reversion do
  parts = PROJECT_MODULE.split('::')
  File.open("lib/#{GEMSPEC.name}/version.rb", 'w+') do |file|
    file.puts('# frozen_string_literal: true')
    file.puts
    parts.each_with_index { |part, depth| file.puts("#{'  ' * depth}module #{part}") }
    file.puts("#{'  ' * parts.size}VERSION = '#{GEMSPEC.version}'")
    (parts.size - 1).downto(0) { |depth| file.puts("#{'  ' * depth}end") }
  end
end
