require_relative '../helper'

Tk.init

describe Tk::Frame do
  it 'creates a new frame' do
    @frame = Tk::Frame.new(Tk.root)
    @frame.winfo_exists.should == true
  end
end