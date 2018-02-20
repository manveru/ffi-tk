# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Listbox do
  it 'initializes' do
    instance = Tk::Listbox.new
    instance.class.should == Tk::Listbox
    instance.tk_parent.should == Tk.root
  end

  it 'Make sure we get contents of the list' do
    list = Tk::Listbox.new
    list.insert 0, 'first line'
    list.get(0).should == 'first line'
    list.insert 1, 'second line'
    list.get(1).should == 'second line'
    list.get(0, 1).should == ['first line', 'second line']
    list.value.should == ['first line', 'second line']
  end
end
