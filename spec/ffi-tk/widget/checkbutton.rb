# frozen_string_literal: true

require_relative '../../helper'

describe Tk::CheckButton do
  it 'initializes' do
    cb = Tk::CheckButton.new
    cb.class.should == Tk::CheckButton
    cb.tk_parent.should == Tk.root
    cb.destroy
  end

  it 'reports -indicatoron as a boolean' do
    cb = Tk::CheckButton.new
    cb.cget(:indicatoron).should == true
    cb.configure(indicatoron: false)
    cb.cget(:indicatoron).should == false
    cb.destroy
  end

  it 'associates a variable with the value' do
    value = Tk::Variable.new('checkbutton_value')
    cb = Tk::CheckButton.new(variable: value)
    value.to_boolean.should == false
    cb.select
    value.to_boolean.should == true
    cb.deselect
    value.to_boolean.should == false
  end

  it 'toggles state and returns the command result from invoke' do
    value = Tk::Variable.new('checkbutton_invoke_value')
    cb = Tk::CheckButton.new(variable: value) { :toggled }

    cb.invoke.should == 'toggled'
    value.to_boolean.should == true
    cb.invoke.should == 'toggled'
    value.to_boolean.should == false
    cb.destroy
  end

  it 'flips the variable via #toggle and flashes without raising' do
    value = Tk::Variable.new('checkbutton_toggle_value')
    cb = Tk::CheckButton.new(variable: value)
    cb.pack

    value.to_boolean.should == false
    cb.toggle
    value.to_boolean.should == true
    cb.toggle
    value.to_boolean.should == false

    -> { cb.flash }.should.not.raise
    cb.destroy
  end

  it 'assigns a command block on initialize' do
    toggled = false
    value = Tk::Variable.new('checkbutton_value')
    cb = Tk::CheckButton.new(variable: value) { toggled = !toggled }
    cb.pack
    cb.focus

    toggled.should == false

    Tk::Wait.visibility(cb)

    Tk::Event.generate(cb, '<1>')
    Tk.interp.do_events_until { toggled }
    toggled.should == true

    Tk::Event.generate(cb, '<1>')
    Tk.interp.do_events_until { !toggled }
    toggled.should == false

    Tk::Event.generate(cb, '<1>')
    Tk.interp.do_events_until { toggled }
    toggled.should == true
  end
end
