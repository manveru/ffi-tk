# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Tile::Sizegrip do
  it 'initializes' do
    instance = Tk::Tile::Sizegrip.new
    instance.class.should == Tk::Tile::Sizegrip
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
