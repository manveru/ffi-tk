# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Tile::LabelFrame do
  it 'initializes' do
    instance = Tk::Tile::LabelFrame.new
    instance.class.should == Tk::Tile::LabelFrame
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
