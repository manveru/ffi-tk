require_relative '../../helper'

describe Tk::CheckButton do
  it 'initializes' do
    instance = Tk::CheckButton.new
    instance.class.should == Tk::CheckButton
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
