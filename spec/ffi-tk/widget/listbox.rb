require_relative '../../helper'

describe Tk::Listbox do
  it 'initializes' do
    instance = Tk::Listbox.new
    instance.class.should == Tk::Listbox
    instance.parent.should == Tk.root
  end

  it 'Make sure we get contents of the list' do
    list = Tk::Listbox.new
    list.insert 0, "first line"
    list.get(0).should == "first line"
  end
end
