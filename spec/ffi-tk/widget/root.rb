require_relative '../../helper'

describe Tk::Root do
  it 'initializes' do
    instance = Tk::Root.new
    instance.class.should == Tk::Root
    instance.tk_parent.should == nil
  end
end
