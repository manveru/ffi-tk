require_relative '../../helper'

describe Tk::Listbox do
  it 'initializes' do
    instance = Tk::Listbox.new
    instance.class.should == Tk::Listbox
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
