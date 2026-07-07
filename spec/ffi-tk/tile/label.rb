# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Tile::Label do
  it 'initializes' do
    instance = Tk::Tile::Label.new
    instance.class.should == Tk::Tile::Label
    instance.tk_parent.should == Tk.root
  end

  # #value reads -text, a :string option: an unset label reports "" (the empty
  # instance of the type), not nil.
  it 'assigns a value' do
    label = Tk::Tile::Label.new
    label.value.should == ''
    label.value = 'Hello, World!'
    label.value.should == 'Hello, World!'
  end
end
