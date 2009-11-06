require 'pathname'

Dir.glob('lib/ffi-tk/widget/*.rb') do |path|
  path = Pathname(path)

  dest = Pathname("spec/ffi-tk/widget/#{path.basename}")
  next if dest.file?

  line = path.open{|io| io.grep(/class/) }.first
  klass = "Tk::#{line[/class (\w+)/, 1]}"

  dest.open('w+'){|io|
    io.puts "require_relative '../../helper'"
    io.puts
    io.puts "describe #{klass} do"
    io.puts "  it 'initializes' do"
    io.puts "    instance = #{klass}.new"
    io.puts "    instance.class.should == #{klass}"
    io.puts "    instance.parent.should == Tk.root"
    io.puts "  end"
    io.puts
    io.puts "  it 'needs more specs' do"
    io.puts "  end"
    io.puts "end"
  }
end