require_relative '../../helper'

describe Tk::Scale do
  it 'initializes' do
    instance = Tk::Scale.new
    instance.class.should == Tk::Scale
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
