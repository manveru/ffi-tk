require_relative '../../helper'

describe Tk::Tile::Scale do
  it 'initializes' do
    instance = Tk::Tile::Scale.new
    instance.class.should == Tk::Tile::Scale
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

