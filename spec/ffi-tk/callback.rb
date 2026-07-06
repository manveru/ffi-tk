# frozen_string_literal: true

require_relative '../helper'

# The value a Ruby callback returns becomes the Tcl result of the
# RubyFFI::callback invocation (Interp#obj_result= builds a real Tcl_Obj for
# it; passing anything else crashed in Tcl_GetStringFromObj, so these are
# regression specs as much as round-trips).
describe 'Ruby callback results' do
  def callback_result(value)
    id, command = Tk.register_proc(proc { value })
    Tk.interp.eval(command)
    Tk.interp.guess_result
  ensure
    Tk.unregister_proc(id)
  end

  it 'returns nil for a nil result' do
    callback_result(nil).should.nil?
  end

  it 'round-trips strings and symbols' do
    callback_result('plain').should == 'plain'
    callback_result(:symbol).should == 'symbol'
  end

  it 'round-trips integers beyond 32 bits' do
    callback_result(2**40).should == 2**40
    callback_result(-42).should == -42
  end

  it 'round-trips floats' do
    callback_result(1.25).should == 1.25
  end

  it 'round-trips arrays as Tcl lists, including nested ones' do
    callback_result([1, 'two', 3.5]).should == [1, 'two', 3.5]
    callback_result([1, [2, 3]]).should == [1, [2, 3]]
  end

  it 'represents booleans as Tcl booleans' do
    callback_result(true).should == 1
    callback_result(false).should == 0
  end

  it 'raises the exception message through the Tcl error path' do
    id, command = Tk.register_proc(proc { raise 'boom' })
    -> { Tk.interp.eval(command) }.should.raise(RuntimeError)
  ensure
    Tk.unregister_proc(id)
  end
end
