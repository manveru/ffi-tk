require_relative '../../helper'

describe Tk::Menu do
  it 'initializes' do
    instance = Tk::Menu.new
    instance.class.should == Tk::Menu
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
