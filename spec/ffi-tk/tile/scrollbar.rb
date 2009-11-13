require_relative '../../helper'

describe Tk::Tile::Scrollbar do
  it 'initializes' do
    instance = Tk::Tile::Scrollbar.new
    instance.class.should == Tk::Tile::Scrollbar
    instance.parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end

describe Tk::Tile::YScrollbar do
  it 'initializes' do
    instance = Tk::Tile::YScrollbar.new
    instance.class.should == Tk::Tile::YScrollbar
    instance.parent.should == Tk.root
  end

  it 'sets orient' do
    s = Tk::Tile::YScrollbar.new
    s.cget(:orient).should == :vertical
  end
end

describe Tk::Tile::XScrollbar do
  it 'initializes' do
    instance = Tk::Tile::XScrollbar.new
    instance.class.should == Tk::Tile::XScrollbar
    instance.parent.should == Tk.root
  end

  it 'sets orient' do
    s = Tk::Tile::XScrollbar.new
    s.cget(:orient).should == :horizontal
  end
end

