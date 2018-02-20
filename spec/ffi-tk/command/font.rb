# frozen_string_literal: true
require_relative '../../helper'

Tk.init

describe Tk::Font do
  it 'lists names of all named fonts' do
    Tk::Font.names.sort.select { |name| name.match(/^Tk./) }.should == %w(
      TkCaptionFont TkDefaultFont TkFixedFont TkHeadingFont
      TkIconFont TkMenuFont TkSmallCaptionFont TkTextFont
      TkTooltipFont
    )
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
end
