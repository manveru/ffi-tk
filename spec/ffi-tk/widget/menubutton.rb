require_relative '../../helper'

describe Tk::MenuButton do
  it 'initializes' do
    instance = Tk::MenuButton.new
    instance.class.should == Tk::MenuButton
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
