# frozen_string_literal: true

require_relative '../helper'

describe Tk::TkGeometry do
  it 'parses a full size+position geometry' do
    g = Tk::TkGeometry.new('=100x200+10+20')
    g.width.should == 100
    g.height.should == 200
    g.x.should == 10
    g.y.should == 20
    g.original.should == '=100x200+10+20'
  end

  it 'parses a size-only geometry' do
    g = Tk::TkGeometry.new('100x200')
    g.width.should == 100
    g.height.should == 200
    g.x.should.be.nil
    g.y.should.be.nil
  end

  it 'parses a position-only geometry with negative offsets' do
    g = Tk::TkGeometry.new('+10-20')
    g.x.should == 10
    g.y.should == -20
    g.width.should.be.nil
    g.height.should.be.nil
  end

  it 'raises on an invalid geometry' do
    should.raise(RuntimeError) { Tk::TkGeometry.new('nonsense') }
  end

  it 'serialises size+position back to a Tcl geometry string' do
    Tk::TkGeometry.new('=100x200+10+20').to_tcl.should == '=100x200+10+20'
  end

  it 'serialises a size-only geometry (regression: used to raise)' do
    Tk::TkGeometry.new('100x200').to_tcl.should == '=100x200'
  end

  it 'serialises a position-only geometry (regression: used to drop x)' do
    Tk::TkGeometry.new('+10-20').to_tcl.should == '=+10-20'
  end

  it 'round-trips every branch through the parser' do
    ['=100x200+10+20', '100x200', '+10-20'].each do |spec|
      g = Tk::TkGeometry.new(spec)
      round = Tk::TkGeometry.new(g.to_tcl)
      [round.width, round.height, round.x, round.y].should ==
        [g.width, g.height, g.x, g.y]
    end
  end
end
