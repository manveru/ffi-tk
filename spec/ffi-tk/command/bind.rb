# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Bind do
  entry = Tk::Entry.new
  entry.pack
  entry.focus

  it 'should bind a block' do
    foo = false
    entry.bind('f') { foo = true }
    Tk.interp.do_events_until do
      Tk::Event.generate(entry, 'f')
      foo
    end
    foo.should == true
  end

  it 'should return the bound proc' do
    entry.bind('f').should == ' ::RubyFFI::event 0 "f" %# %b %c %d %f %h %i %k %m %o %p %s %t %w %x %y %A %B %D %E %K %N %P %R %S %T %W %X %Y '
  end

  it 'should list the sequences bound' do
    entry.bind.should == ['f']
  end
end
