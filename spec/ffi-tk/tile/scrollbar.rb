# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Tile::Scrollbar do
  it 'initializes bare, keeping ttk default orientation' do
    s = Tk::Tile::Scrollbar.new
    s.class.should == Tk::Tile::Scrollbar
    s.cget(:orient).should == :vertical
  end

  it 'round-trips orientation through the inherited orient method' do
    s = Tk::Tile::Scrollbar.new
    s.orient(:horizontal)
    s.orient.should == :horizontal
    s.orient(:vertical)
    s.orient.should == :vertical
  end
end

describe Tk::Tile::YScrollbar do
  it 'initializes' do
    instance = Tk::Tile::YScrollbar.new
    instance.class.should == Tk::Tile::YScrollbar
    instance.tk_parent.should == Tk.root
  end

  it 'sets orientation' do
    s = Tk::Tile::YScrollbar.new
    s.cget(:orient).should == :vertical
  end
end

describe Tk::Tile::XScrollbar do
  it 'initializes' do
    instance = Tk::Tile::XScrollbar.new
    instance.class.should == Tk::Tile::XScrollbar
    instance.tk_parent.should == Tk.root
  end

  it 'sets orientation' do
    s = Tk::Tile::XScrollbar.new
    s.cget(:orient).should == :horizontal
  end
end
