require_relative '../../helper'

describe Tk::PanedWindow do
  it 'initializes' do
    instance = Tk::PanedWindow.new
    instance.class.should == Tk::PanedWindow
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
