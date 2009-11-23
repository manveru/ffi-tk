require_relative '../../helper'

describe Tk::LabelFrame do
  it 'initializes' do
    instance = Tk::LabelFrame.new
    instance.class.should == Tk::LabelFrame
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
