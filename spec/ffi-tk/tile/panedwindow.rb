require_relative '../../helper'

describe Tk::Tile::PanedWindow do
  it 'initializes' do
    instance = Tk::Tile::PanedWindow.new
    instance.class.should == Tk::Tile::PanedWindow
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

