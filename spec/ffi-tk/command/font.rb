# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Font do
  it 'lists names of all named fonts' do
    Tk::Font.names.sort.select { |name| name.match(/^Tk./) }.should == %w[
      TkCaptionFont TkDefaultFont TkFixedFont TkHeadingFont
      TkIconFont TkMenuFont TkSmallCaptionFont TkTextFont
      TkTooltipFont
    ]
  end

  it 'measures a character' do
    Tk::Font.measure('TkDefaultFont', '0').should >= 4
  end

  it 'shows metrics of a font' do
    Tk::Font.metrics('TkDefaultFont', :ascent).should >= 11
    Tk::Font.metrics('TkDefaultFont', :descent).should == 3
    Tk::Font.metrics('TkDefaultFont', :linespace).should >= 14
    Tk::Font.metrics('TkDefaultFont', :fixed).should == 0
  end

  it 'lists all font families on the system' do
    Tk::Font.families.size.should > 0
  end

  it 'creates a font' do
    Tk::Font.create('DejaVuSans').should == 'DejaVuSans'
    Tk::Font.names.sort.should.include('DejaVuSans')

    lambda do
      Tk::Font.create('DejaVuSans')
    end.should.raise.message =~ /^named font "DejaVuSans" already exists/
  end

  it 'show configuration for our font' do
    conf = Tk::Font.configure('DejaVuSans')
    conf[:family].should == ''
    conf[:size].should == 0
    conf[:weight].should == :normal
    conf[:slant].should == :roman
    conf[:underline].should == false
    conf[:overstrike].should == false
  end

  it 'manipulates configuration of our font' do
    Tk::Font.configure('DejaVuSans', size: 10)
    Tk::Font.configure('DejaVuSans')[:size].should == 10
  end

  it 'shows actual information about the font' do
    conf = Tk::Font.actual('DejaVuSans')
    conf[:family].should.not == ''
    conf[:size].should == 10
    conf[:weight].should == :normal
    conf[:slant].should == :roman
    conf[:underline].should == false
    conf[:overstrike].should == false
  end

  it 'deletes the font' do
    Tk::Font.delete('DejaVuSans')
    Tk::Font.names.should.not.include('DejaVuSans')
  end

  it 'creates a named font from an options hash (two-arg form)' do
    Tk::Font.create('SpecStyledFont', family: 'DejaVu Sans', size: 14,
                                      weight: :bold, slant: :italic).should == 'SpecStyledFont'
    Tk::Font.names.should.include('SpecStyledFont')

    conf = Tk::Font.configure('SpecStyledFont')
    conf[:family].should == 'DejaVu Sans'
    conf[:size].should == 14
    conf[:weight].should == :bold
    conf[:slant].should == :italic

    Tk::Font.delete('SpecStyledFont')
    Tk::Font.names.should.not.include('SpecStyledFont')
  end

  it 'queries a single actual attribute via :option' do
    font = Tk::Font.create(family: 'DejaVu Sans', size: 12)

    Tk::Font.actual(font, option: :family).should == Tk::Font.actual(font)[:family]
    Tk::Font.actual(font, option: :size).is_a?(Integer).should == true
    Tk::Font.actual(font, option: :size).should == 12

    Tk::Font.delete(font)
  end

  it 'reports actual attributes for a specific character via :char' do
    font = Tk::Font.create(family: 'DejaVu Sans', size: 12)

    actual = Tk::Font.actual(font, char: 'A')
    actual.is_a?(Hash).should == true
    actual[:family].is_a?(String).should == true
    actual[:size].should == 12

    Tk::Font.delete(font)
  end

  it 'measures wider text as strictly wider than narrower text' do
    font = Tk::Font.create(family: 'DejaVu Sans', size: 12)

    wide = Tk::Font.measure(font, 'xxxx')
    narrow = Tk::Font.measure(font, 'x')
    wide.is_a?(Integer).should == true
    narrow.is_a?(Integer).should == true
    wide.should > narrow

    Tk::Font.delete(font)
  end

  it 'returns integer metrics with linespace covering ascent plus descent' do
    font = Tk::Font.create(family: 'DejaVu Sans', size: 12)

    ascent = Tk::Font.metrics(font, :ascent)
    descent = Tk::Font.metrics(font, :descent)
    linespace = Tk::Font.metrics(font, :linespace)
    [ascent, descent, linespace].all? { |m| m.is_a?(Integer) }.should == true
    ascent.should > 0
    descent.should > 0
    linespace.should >= (ascent + descent)

    Tk::Font.delete(font)
  end

  it 'lists font families as a non-empty array of String names' do
    families = Tk::Font.families
    families.is_a?(Array).should == true
    families.size.should > 0
    families.all? { |name| name.is_a?(String) }.should == true
  end

  it 'wraps a named font with instance actual/configure/measure/metrics' do
    font = Tk::Font.new(family: 'DejaVu Sans', size: 12)

    conf = font.configure
    conf[:family].should == 'DejaVu Sans'
    conf[:size].should == 12

    font.actual[:family].should == conf[:family]
    font.measure('xx').should > font.measure('x')
    font.metrics(:ascent).is_a?(Integer).should == true
  end

  it 'builds a font from a family-and-size string' do
    font = Tk::Font.new('DejaVu Sans 10')
    font.configure[:size].should == 10
    font.configure[:family].should == 'DejaVu Sans'
  end

  it 'rejects a font spec that is neither a string nor a hash' do
    -> { Tk::Font.new(42) }.should.raise(ArgumentError)
  end

  it 'exposes actual_hash and renders the font name via to_tcl' do
    font = Tk::Font.new(family: 'DejaVu Sans', size: 11)
    font.actual_hash[:family].should == 'DejaVu Sans'
    font.actual_hash[:size].should == 11
    # to_tcl carries the underlying named-font token
    font.to_tcl.to_s.should =~ /\Afont\d+\z/
  end
end
