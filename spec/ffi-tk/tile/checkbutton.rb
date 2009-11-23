require_relative '../../helper'

describe Tk::Tile::CheckButton do
  it 'initializes' do
    instance = Tk::Tile::CheckButton.new
    instance.class.should == Tk::Tile::CheckButton
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

