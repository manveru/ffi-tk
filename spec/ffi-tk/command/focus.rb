# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Focus do
  before { reset_root! }

  it 'reports the current focus as a String' do
    Tk::Focus.focus.is_a?(String).should == true
  end

  it 'moves the focus to a mapped widget' do
    entry = Tk::Entry.new('.')
    entry.place(x: 0, y: 0, width: 120, height: 24)
    next unless skip_unless_mapped(entry)

    Tk::Focus.focus(entry, :force)

    delivered = false
    30.times do
      Tk.execute('update')
      break (delivered = true) if Tk::Focus.focus == entry.tk_pathname

      sleep 0.02
    end
    delivered.should == true
    Tk::Focus.focus.should == entry.tk_pathname
    Tk::Focus.focus(entry, :displayof).should == entry.tk_pathname
  end

  it 'walks the keyboard traversal order with next and prev' do
    first = Tk::Entry.new('.')
    second = Tk::Entry.new('.')
    first.place(x: 0, y: 0, width: 120, height: 24)
    second.place(x: 0, y: 30, width: 120, height: 24)
    Tk.execute('update')

    # With exactly two focusable siblings the order is first <-> second.
    Tk::Focus.next(first).should == second.tk_pathname
    Tk::Focus.prev(second).should == first.tk_pathname
  end

  it 'reports the most recently focused window of a toplevel via :lastfor' do
    first = Tk::Entry.new('.')
    second = Tk::Entry.new('.')
    first.place(x: 0, y: 0, width: 120, height: 24)
    second.place(x: 0, y: 30, width: 120, height: 24)
    next unless skip_unless_mapped(first)

    Tk::Focus.focus(second, :force)
    30.times do
      Tk.execute('update')
      break if Tk::Focus.focus == second.tk_pathname

      sleep 0.02
    end

    # lastfor reports a real window within the same toplevel as +first+.
    [first.tk_pathname, second.tk_pathname].should.include(Tk::Focus.focus(first, :lastfor))
  end

  it 'rejects an unknown focus option' do
    entry = Tk::Entry.new('.')
    -> { Tk::Focus.focus(entry, :bogus) }.should.raise(ArgumentError)
  end

  it 'switches to the implicit follows-mouse focus model' do
    -> { Tk::Focus.follows_mouse }.should.not.raise
  end
end
