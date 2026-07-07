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
end
