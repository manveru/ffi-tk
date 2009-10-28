require 'bacon'
Bacon.summary_at_exit

require_relative '../../lib/ffi-tk'

Tk.init

describe Tk::Entry do
  @entry = Tk::Entry.new('.')

  it 'gets content' do
    @entry.get.should == ''
  end

  it 'inserts text at index' do
    @entry.insert(:end, 'Hello, World!')
    @entry.get.should == 'Hello, World!'
  end

  it 'queries bbox of a character' do
    @entry.bbox(0).should == [3, -7, 6, 15]
  end
end