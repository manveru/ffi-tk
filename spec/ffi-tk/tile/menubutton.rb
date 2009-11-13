require_relative '../../helper'

describe Tk::Tile::MenuButton do
  it 'initializes' do
    instance = Tk::Tile::MenuButton.new
    instance.class.should == Tk::Tile::MenuButton
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

