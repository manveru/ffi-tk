# frozen_string_literal: true

require_relative '../helper'

Tk.init

describe FFI::Tcl::Interp do
  interp = Tk.interp

  describe '#tcl_time' do
    it 'converts a fractional-second timeout to seconds + microseconds' do
      t = interp.tcl_time(0.05)
      t.seconds.should == 0
      t.microseconds.should == 50_000
    end

    it 'splits whole seconds from the fractional remainder' do
      t = interp.tcl_time(2.25)
      t.seconds.should == 2
      t.microseconds.should == 250_000
    end

    it 'returns nil for a non-positive duration (block/poll)' do
      interp.tcl_time(0).should.nil?
      interp.tcl_time(nil).should.nil?
    end
  end
end
