# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Frame do
  it 'creates a new frame' do
    @frame = Tk::Frame.new
    @frame.winfo_exists.should == true
  end
end
