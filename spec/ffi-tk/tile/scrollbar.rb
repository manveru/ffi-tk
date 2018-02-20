# frozen_string_literal: true
require_relative '../../helper'

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
