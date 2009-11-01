require_relative '../../helper'

Tk.init

describe Tk::Clipboard do
  C = Tk::Clipboard

  it 'should clear the clipboard' do
    C.clear
    lambda{ C.get }.should.raise.message.
      should =~ /^CLIPBOARD selection doesn't exist or form "STRING" not defined/
  end

  it 'should append to the clipboard' do
    C.append data: 'something'
    C.get.should == 'something'
  end
end