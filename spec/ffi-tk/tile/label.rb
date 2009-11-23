require_relative '../../helper'

describe Tk::Tile::Label do
  it 'initializes' do
    instance = Tk::Tile::Label.new
    instance.class.should == Tk::Tile::Label
    instance.tk_parent.should == Tk.root
  end

  it 'assigns a value' do
    label = Tk::Tile::Label.new
    label.value.should == nil
    label.value = 'Hello, World!'
    label.value.should == 'Hello, World!'
  end
end

