# frozen_string_literal: true

# Once git has a fix for the glibc in handling .mailmap and another fix for
# allowing empty mail address to be mapped in .mailmap we won't have to handle
# them manually.

desc 'Update AUTHORS'
task :authors do
  authors = Hash.new(0)

  # Michael's historical commit addresses, folded into the canonical one below.
  michael_emails = %w[
    michael.fellinger@xing.com
    michael.fellinger@iohk.io
  ].freeze

  # `git shortlog` reads its commit list from stdin when given no revision, so
  # in a non-tty subprocess (rake) it sees EOF and prints nothing, wiping
  # AUTHORS. Passing HEAD makes it walk history instead.
  `git shortlog -nse HEAD`.scan(/(\d+)\s(.+)\s<(.*)>$/) do |count, name, email|
    email = 'm.fellinger@gmail.com' if michael_emails.include?(email)
    authors[[name, email]] += count.to_i
  end

  File.open('AUTHORS', 'w+') do |io|
    io.puts "Following persons have contributed to #{GEMSPEC.name}."
    io.puts '(Sorted by number of submitted patches, then alphabetically)'
    io.puts ''
    authors.sort_by { |(n, _e), c| [-c, n.downcase] }.each do |(name, email), count|
      io.puts(format('%6d %s <%s>', count, name, email))
    end
  end
end
