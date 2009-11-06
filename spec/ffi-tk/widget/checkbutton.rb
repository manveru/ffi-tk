require_relative '../../helper'

describe Tk::CheckButton do
  it 'initializes' do
    cb = Tk::CheckButton.new
    cb.class.should == Tk::CheckButton
    cb.parent.should == Tk.root
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

  it 'assigns a command block on initialize' do
    toggled = false
    value = Tk::Variable.new('checkbutton_value')
    cb = Tk::CheckButton.new(variable: value){ toggled = !toggled }
    cb.pack
    cb.focus

    toggled.should == false

    Tk::Wait.visibility(cb)

    Tk::Event.generate(cb, '<1>')
    Tk.interp.do_events_until{ toggled }
    toggled.should == true

    Tk::Event.generate(cb, '<1>')
    Tk.interp.do_events_until{ !toggled }
    toggled.should == false

    Tk::Event.generate(cb, '<1>')
    Tk.interp.do_events_until{ toggled }
    toggled.should == true
  end
end