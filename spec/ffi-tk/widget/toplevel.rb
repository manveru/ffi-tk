require_relative '../../helper'

describe Tk::Toplevel do
  it 'initializes' do
    instance = Tk::Toplevel.new
    instance.class.should == Tk::Toplevel
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
