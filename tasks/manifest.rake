# frozen_string_literal: true
desc 'update manifest'
task :manifest do
  File.open('MANIFEST', 'w+') { |io| io.puts(*GEMSPEC.files) }
end
