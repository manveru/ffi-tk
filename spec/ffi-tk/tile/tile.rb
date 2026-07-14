# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Tile do
  it 'builds a dotted style name from a style and a parent path (::-stripped)' do
    Tk::Tile.style('TButton', 'Foo::Bar').should == 'TButton.Bar'
    Tk::Tile.style('TEntry', '.frame.entry').should == 'TEntry..frame.entry'
  end

  it 'sets the current theme through set_theme' do
    Tk::Tile.set_theme('default').should == 'default'
    Tk::Tile.set_theme('no-such-theme').should.be.nil
  end

  it 'grids a tile widget through the TileWidget#grid shortcut' do
    button = Tk::Tile::Button.new(Tk.root, text: 'gridded')
    button.grid(row: 1, column: 2)
    info = button.grid_info
    info[:row].should == 1
    info[:column].should == 2
  end
end
