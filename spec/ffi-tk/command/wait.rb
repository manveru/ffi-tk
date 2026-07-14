# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Wait do
  it 'returns once a watched variable is written' do
    Tk.eval('after 50 { set ::ffitk_waitvar 1 }')
    Tk::Wait.variable('::ffitk_waitvar')
    Tk.execute_string(:set, '::ffitk_waitvar').should == '1'
  end

  it 'returns once a window is destroyed' do
    Tk.execute_only(:toplevel, '.waitwin')
    Tk.execute_string(:winfo, :exists, '.waitwin').should == '1'
    Tk.eval('after 50 { destroy .waitwin }')
    Tk::Wait.window('.waitwin')
    Tk.execute_string(:winfo, :exists, '.waitwin').should == '0'
  end

  it 'returns once a window becomes visible' do
    Tk.execute_only(:toplevel, '.viswin')
    Tk::Wait.visibility('.viswin')
    Tk.execute_string(:winfo, :viewable, '.viswin').should == '1'
    Tk.execute_only(:destroy, '.viswin')
  end

  # Regression guard for the GVL fix: Tcl_EvalEx is attached blocking: true so
  # tkwait releases the GVL while it pumps events. A background Ruby thread must
  # therefore keep making progress for the whole wait; without the fix it would
  # be frozen (~0 wakeups) for the dialog's entire lifetime.
  it 'lets other Ruby threads run while blocking' do
    progress = 0
    worker = Thread.new do
      loop do
        progress += 1
        sleep 0.005
      end
    end

    Tk.execute_only(:toplevel, '.busywin')
    Tk.eval('after 300 { destroy .busywin }')
    Tk::Wait.window('.busywin')
    worker.kill

    progress.should.be > 10
  end
end
