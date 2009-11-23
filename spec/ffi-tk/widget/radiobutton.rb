require_relative '../../helper'

describe Tk::RadioButton do
  it 'initializes' do
    instance = Tk::RadioButton.new
    instance.class.should == Tk::RadioButton
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
