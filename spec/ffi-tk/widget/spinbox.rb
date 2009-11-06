require_relative '../../helper'

describe Tk::Spinbox do
  it 'initializes' do
    instance = Tk::Spinbox.new
    instance.class.should == Tk::Spinbox
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
