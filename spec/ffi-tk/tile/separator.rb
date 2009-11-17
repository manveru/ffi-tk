require_relative '../../helper'

describe Tk::Tile::Separator do
  it 'initializes' do
    instance = Tk::Tile::Separator.new
    instance.class.should == Tk::Tile::Separator
    instance.parent.should == Tk.root
  end

  it 'sets orientation' do
    s = Tk::Tile::Separator.new
    s.orient.should == :horizontal
    s.orient :vertical
    s.orient.should == :vertical
  end

  it 'sets identify' do
    s = Tk::Tile::Separator.new
    s.identify(0,0).should == true 
  end
end

