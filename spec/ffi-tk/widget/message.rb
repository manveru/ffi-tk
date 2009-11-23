require_relative '../../helper'

describe Tk::Message do
  it 'initializes' do
    instance = Tk::Message.new
    instance.class.should == Tk::Message
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
