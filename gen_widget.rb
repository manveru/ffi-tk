widget, klass = ARGV

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

manpage = `man #{widget}`
lines = manpage.lines.to_a

commands = {}
signature = nil
comment = []
indent = 14

while line = lines.shift
  if line =~ /^(\s+)pathName\s+(.+)/
    commands[signature] = comment if signature
    indent = $1
    signature = $2
    comment = []
  elsif line =~ /^#{indent}\s{7}(.+)/
    comment << line.strip
  end
end

commands[signature] = comment if signature

instance_methods = []

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
  instance_methods << [
    comment_lines.join("\n").rstrip.gsub(/^(\s+)\s{3}/, '\1# '),
    "    def #{name}#{sig_args}",
    "      execute(:#{name}#{body})",
    "    end",
  ]
end

path = "lib/ffi-tk/widget/#{widget}.rb"
File.open(path, 'w+') do |io|
  io.puts 'module Tk'
  io.puts "  class #{klass}"
  io.puts "    def initialize(parent, options = {})"
  io.puts "      @parent = parent"
  io.puts "      Tk.execute('#{widget}', assign_pathname, options.to_tcl_options)"
  io.puts "    end"
  instance_methods.each do |lines|
    io.puts
    io.puts lines
  end
  io.puts "  end"
  io.puts "end"
end

system('less', path)