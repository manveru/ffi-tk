require_relative '../../helper'

describe Tk::Tile::RadioButton do
  it 'initializes' do
    instance = Tk::Tile::RadioButton.new
    instance.class.should == Tk::Tile::RadioButton
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

