# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Scale do
  it 'initializes' do
    instance = Tk::Scale.new
    instance.class.should == Tk::Scale
    instance.tk_parent.should == Tk.root
  end

  it 'coerces its numeric options by declared type' do
    scale = Tk::Scale.new
    scale.configure(from: 1.5, to: 9.5, resolution: 0.5, digits: 3)

    scale.cget(:from).should == 1.5
    scale.cget(:to).should == 9.5
    scale.cget(:resolution).should == 0.5
    scale.cget(:digits).should == 3
    # -length is a screen distance, kept as its raw string.
    scale.cget(:length).should.be.kind_of(String)
    scale.cget(:showvalue).should == true
    scale.destroy
  end

  it 'sets the value and reads it back through get' do
    scale = Tk::Scale.new(from: 0, to: 100)
    scale.pack
    scale.set(42)
    scale.get.to_i.should == 42 # get returns the value as a Tcl string
    scale.destroy
  end

  it 'maps a value to trough coordinates and a pixel to an element' do
    scale = Tk::Scale.new(from: 0, to: 100, length: 200)
    scale.pack
    next unless skip_unless_mapped(scale)

    coords = scale.coords(50)
    coords.should.be.is_a? Array
    coords.size.should == 2
    coords.all? { |n| n.is_a?(Integer) }.should == true

    # a pixel inside the widget resolves to a value; and identify names a part.
    scale.get(coords[0], coords[1]).to_i.should.be.is_a? Integer
    %w[slider trough1 trough2].should.include scale.identify(coords[0], coords[1])
    scale.destroy
  end
end
