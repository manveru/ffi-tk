# frozen_string_literal: true
require_relative '../../helper'

Tk.init

describe Tk::Pack do
  @button = Tk::Button.new('.')

  it 'packs a widget' do
    Tk::Pack.pack(@button)
    Tk::Pack.info(@button).should == {
      in: '.', anchor: 'center', expand: false, fill: :none, ipadx: 0, ipady: 0,
      padx: 0, pady: 0, side: :top
    }
  end

  it 'forgets the packing' do
    Tk::Pack.forget(@button)
    -> { Tk::Pack.info(@button) }.should.raise
  end
end
