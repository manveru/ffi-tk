# frozen_string_literal: true

require_relative '../../helper'

# Specs for the raw-string read plumbing the option path is built on:
# Interp#result_string, Tk.execute_string and Widget#execute_string. These
# return the result's raw Tcl string and must never route through
# EvalResult.guess (which would type-guess and shimmer).
describe 'option read plumbing' do
  it 'Interp#result_string returns the raw string of the current result' do
    Tk.interp.eval('set x hello')
    Tk.interp.result_string.should == 'hello'
  end

  it 'Tk.execute_string returns the raw string, not a guessed value' do
    # Tk.execute would guess this to the Integer 2; execute_string keeps "2".
    value = Tk.execute_string('expr', '1 + 1')
    value.should == '2'
    value.class.should == String
  end

  it 'Widget#execute_string returns a widget result as a raw string' do
    entry = Tk::Entry.new
    entry.execute_string('cget', '-borderwidth').class.should == String
  end
end
