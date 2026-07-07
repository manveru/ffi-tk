# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Tile::PanedWindow do
  it 'initializes' do
    instance = Tk::Tile::PanedWindow.new
    instance.class.should == Tk::Tile::PanedWindow
    instance.tk_parent.should == Tk.root
  end

  it 'reads pane options as a coerced flat hash and single value' do
    pw = Tk::Tile::PanedWindow.new
    child = Tk::Tile::Frame.new(pw)
    pw.add(child, weight: 2)

    pw.pane(child).should == { weight: 2 }
    pw.pane(child, :weight).should == 2
  end

  it 'sets a pane option and reads it back' do
    pw = Tk::Tile::PanedWindow.new
    child = Tk::Tile::Frame.new(pw)
    pw.add(child, weight: 1)

    pw.pane(child, weight: 3)
    pw.pane(child, :weight).should == 3
  end
end
