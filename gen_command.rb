command, mod = ARGV

def wrap_lines_of(text, wrap = 80)
  raise ArgumentError, "+wrap+ must be > 1" unless wrap > 1
  wrap -= 1

  indent = text[/^\s+/] || ''
  indent_size = indent.size
  lines = [indent.dup]

  text.scan(/\S+/) do |chunk|
    last = lines.last
    last_size = last.size
    chunk_size = chunk.size

    if last_size + chunk_size > wrap
      lines << indent + chunk
    elsif last_size == indent_size
      last << chunk
    elsif chunk =~ /\.$/
      last << ' ' << chunk
      lines << indent.dup
    else
      last << ' ' << chunk
    end
  end

  lines
end

manpage = `man #{command}`
lines = manpage[/^DESCRIPTION.*?forms.*?:(.*)(EXAMPLES|KEYWORDS)/m, 1].lines.to_a

commands = {}
signature = nil
comment = []

while line = lines.shift
  if line =~ /^\s{7}#{command} (?!- Return)(.*)/
    commands[signature] = comment if signature
    signature = $1
    comment = []
  elsif line =~ /^\s{14}(.+)/
    comment << line.strip
  end
end

instance_methods = []
singleton_methods = []

commands.each do |signature, comment|
  name, args = signature.split(' ', 2)

  args ||= ''

  if args.empty?
    sig_args = ''
    body = ""
  else
    sig_args = "(#{args})"
    body = ", #{args}"
  end

  comment_lines = wrap_lines_of((' ' * 7) + comment.join(' '))
  singleton_methods << [
    comment_lines.join("\n").rstrip.gsub(/^(\s+)\s{3}/, '\1# '),
    "    def #{name}#{sig_args}",
    "      Tk.execute(:#{command}, :#{name}#{body})",
    "    end",
  ]

  args = args.sub(/^\??window\?(, )?/, '').strip

  if args.empty?
    sig_args = ''
    body = "#{mod}.#{name}(self)"
  else
    sig_args = "(#{args})"
    body = "#{mod}.#{name}(self, #{args})"
  end

  instance_methods << [
    "    # @see #{mod}.#{name}",
    "    def #{command}_#{name}#{sig_args}",
    "      #{body}",
    "    end"
  ]
end


puts 'module Tk'
puts "  module #{mod}"
instance_methods.each do |lines|
  puts
  puts lines
end
puts "", "    module_function"
singleton_methods.each do |lines|
  puts
  puts lines
end
puts "  end"
puts "end"