require_relative '../../helper'

describe Tk::Tile::Label do
  it 'initializes' do
    instance = Tk::Tile::Label.new
    instance.class.should == Tk::Tile::Label
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

