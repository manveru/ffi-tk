# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Label do
  it 'initializes' do
    instance = Tk::Label.new
    instance.class.should == Tk::Label
    instance.tk_parent.should == Tk.root
  end

  it 'round-trips its value' do
    label = Tk::Label.new
    # -text is :string; an unset label reports the empty instance of the type
    # ("") under the empty-value rule, not nil.
    label.value.should == ''
    label.value = 'Hello, World!'
    label.value.should == 'Hello, World!'
  end
end
