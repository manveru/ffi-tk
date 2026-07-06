# frozen_string_literal: true

require_relative '../../helper'

describe Tk::RadioButton do
  it 'initializes' do
    instance = Tk::RadioButton.new
    instance.class.should == Tk::RadioButton
    instance.tk_parent.should == Tk.root
  end

  it 'selects its value and returns the command result from invoke' do
    value = Tk::Variable.new('radiobutton_invoke_value')
    rb = Tk::RadioButton.new(variable: value, value: 'chosen') { 42 }

    rb.invoke.should == 42
    value.get.should == 'chosen'
    rb.destroy
  end
end
