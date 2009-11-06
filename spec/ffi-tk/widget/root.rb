require_relative '../../helper'

describe Tk::Root do
  it 'initializes' do
    instance = Tk::Root.new
    instance.class.should == Tk::Root
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
