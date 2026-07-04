# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Grab do
  # Only ever exercise LOCAL grabs: a global grab locks the whole display and
  # could wedge the test run (see the warning in lib/ffi-tk/command/grab.rb).
  # A bare frame is 1x1 and never counts as "mapped"; give it a real size so
  # skip_unless_mapped passes on a real display and grab set has a viewable window.
  frame = Tk::Frame.new(Tk.root, width: 50, height: 50)
  Tk.execute_only('pack', frame)

  after { Tk::Grab.release(frame) }

  it 'reports no current grab initially' do
    next unless skip_unless_mapped(frame)

    Tk::Grab.current(frame).should == ''
  end

  it 'sets a local grab and reports the window as current' do
    next unless skip_unless_mapped(frame)

    Tk::Grab.set_local(frame)
    Tk::Grab.current(frame).should == frame.tk_pathname
  end

  it 'lists grabbed windows across displays' do
    next unless skip_unless_mapped(frame)

    Tk::Grab.set_local(frame)
    Tk::Grab.current.should == [frame.tk_pathname]
  end

  it 'releases the grab' do
    next unless skip_unless_mapped(frame)

    Tk::Grab.set_local(frame)
    Tk::Grab.current(frame).should == frame.tk_pathname
    Tk::Grab.release(frame)
    Tk::Grab.current(frame).should == ''
  end
end
