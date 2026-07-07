# frozen_string_literal: true

require_relative '../../helper'

# Specs for the shared STANDARD OPTIONS schemas. The load-bearing property is
# that every screen-distance option is typed losslessly. Classic widgets built
# on Tk_ConfigureWidget report cget for these as the ORIGINAL distance string
# ("2m", "3c", "2i"), NOT a pixel integer -- and whether a given widget/option
# reports the raw string or pixels is a widget-implementation detail (Label
# -borderwidth -> "2m" but Listbox -borderwidth -> "8"; Text -selectborderwidth
# -> "2m" but Text -insertwidth -> "8"). Because one shared type serves every
# classic widget, a numeric type would make Coercer crash on legitimate values.
describe Tk::Option::Standard do
  def classic = Tk::Option::Standard::CLASSIC
  def ttk = Tk::Option::Standard::TTK
  def coerce(type, raw) = Tk::Option::Coercer.coerce(type, raw)

  # Every options(3tk) STANDARD OPTION that Tk parses with Tk_GetPixels.
  def screen_distance_options
    %i[activeborderwidth borderwidth highlightthickness insertborderwidth
       insertwidth padx pady selectborderwidth wraplength]
  end

  it 'types every screen-distance option losslessly, never numeric' do
    screen_distance_options.each do |name|
      classic.type_for(name).should == :string
    end
  end

  it 'round-trips a suffixed screen distance from cget without raising' do
    # This is the exact form legacy-config widgets return: Label -borderwidth
    # 2m, Label -padx 3m, Button -wraplength 2i, Menu -activeborderwidth 2m,
    # Text -selectborderwidth 2m all report the raw distance string.
    screen_distance_options.each do |name|
      coerce(classic.type_for(name), '2m').should == '2m'
    end
  end

  it 'keeps genuine integers (character index, milliseconds) typed :integer' do
    %i[underline repeatdelay repeatinterval insertofftime insertontime].each do |name|
      classic.type_for(name).should == :integer
    end
  end

  it 'resolves the bd alias to the lossless borderwidth type' do
    classic.type_for(:bd).should == :string
  end

  it 'has no classic screen-distance options in the themed standard set' do
    screen_distance_options.each do |name|
      -> { ttk.type_for(name) }.should.raise(Tk::UnknownOptionType)
    end
  end
end
