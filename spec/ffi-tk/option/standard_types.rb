# frozen_string_literal: true

require_relative '../../helper'

# Pins the Option types of the shared classic STANDARD OPTIONS set by round-trip
# on a representative classic widget (Tk::Entry). One set-then-get per type
# family proves the coercion the whole classic tier relies on; per-widget specs
# then only need to cover their widget-specific options. Set-then-get is exact
# and platform-free.
describe 'classic standard-option types (via Tk::Entry)' do
  entry = Tk::Entry.new

  it ':color options coerce to their String value (background)' do
    entry.configure(background: '#ab12cd')
    entry.cget(:background).should == '#ab12cd'
  end

  it ':symbol options coerce to a Symbol (justify)' do
    entry.configure(justify: :center)
    entry.cget(:justify).should == :center
  end

  it ':boolean options coerce to true/false (exportselection)' do
    entry.configure(exportselection: false)
    entry.cget(:exportselection).should == false
    entry.configure(exportselection: true)
    entry.cget(:exportselection).should == true
  end

  it ':string screen-distance options keep the raw string (borderwidth)' do
    entry.configure(borderwidth: '5')
    entry.cget(:borderwidth).should == '5'
  end

  it ':integer options coerce to an Integer (insertontime)' do
    entry.configure(insertontime: 450)
    entry.cget(:insertontime).should == 450
  end

  it ':font options coerce to their String value (font)' do
    entry.configure(font: 'TkFixedFont')
    entry.cget(:font).should == 'TkFixedFont'
  end
end
