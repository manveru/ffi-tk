# frozen_string_literal: true
require_relative '../../helper'

Tk.init

describe Tk::Tile::Button do
  Style = Tk::Tile::Style
  Button = Tk::Tile::Button

  it 'sets default to normal, active, or disabled' do
    button = Button.new('.')
    button.cget(:default).should == 'normal'

    %w(normal active disabled).each do |state|
      button = Button.new('.', default: state)
      button.cget(:default).should == state
    end

    lambda do
      Button.new('.', default: 'unkown-')
    end.should.raise RuntimeError
  end

  it 'sets width and height' do
    button = Button.new('.')
    button.cget(:width).should == 0

    [10, -10, 10.0, -10.0].each do |i|
      button = Button.new('.', width: i.to_i)
      button.cget(:width).should == i.to_i

      button = Button.new('.', width: i.to_f)
      button.cget(:width).should == i.to_i
    end
  end

  # behaves_like Tk::Button -command
  it 'handles -command' do
    ran = false
    Tk.callbacks.size.should == 0

    button = Button.new('.') do
      ran = true
      button.destroy
    end
    button.invoke

    Tk.callbacks.size.should == 0
    ran.should == true
  end
end
