require_relative '../../helper'

describe Tk::Label do
  it 'initializes' do
    instance = Tk::Label.new
    instance.class.should == Tk::Label
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
