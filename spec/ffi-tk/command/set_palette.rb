# frozen_string_literal: true

require_relative '../../helper'

Tk.init

# tk_setPalette recolours the default palette. Both forms are exercised: a
# single background colour (Tk derives the rest) and explicit option/colour
# pairs. Effects are asserted through a widget's resulting background.
describe 'Tk.set_palette' do
  it 'recolours from a single background colour' do
    Tk.set_palette('#c0c0c0')
    Tk::Frame.new('.').cget(:background).should == '#c0c0c0'
  end

  it 'recolours from explicit option/colour pairs' do
    Tk.set_palette('background', '#102030', 'foreground', '#a0b0c0')
    label = Tk::Label.new('.', text: 'x')
    label.cget(:background).should == '#102030'
    label.cget(:foreground).should == '#a0b0c0'
  end
end
