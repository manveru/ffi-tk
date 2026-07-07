# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Tile::Button do
  Style = Tk::Tile::Style
  Button = Tk::Tile::Button

  it 'sets default to normal, active, or disabled' do
    button = Button.new('.')
    button.cget(:default).should == :normal

    %w[normal active disabled].each do |state|
      button = Button.new('.', default: state)
      button.cget(:default).should == state.to_sym
    end

    lambda do
      Button.new('.', default: 'unkown-')
    end.should.raise RuntimeError
  end

  # -width is a character count (:integer); an unset width reports "" -> nil,
  # not a coerced 0. ttk::button stores a non-integer -width verbatim (e.g.
  # "10.0"), so only integer inputs round-trip losslessly; feeding a Float and
  # expecting an integer back was a legacy to_i artifact, not faithful.
  it 'sets width and height' do
    button = Button.new('.')
    button.cget(:width).should.nil?

    [10, -10].each do |i|
      button = Button.new('.', width: i)
      button.cget(:width).should == i
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
