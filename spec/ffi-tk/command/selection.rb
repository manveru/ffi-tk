require_relative '../../helper'

Tk.init

describe Tk::Selection do
  @entry = Tk::Entry.new('.')
  @entry.insert :end, 'abc def ghi jkl mno pqr stu vwx yz'
  @entry.selection_range(0, 3)

  it 'gets selection' do
    Tk::Selection.get.should == 'abc'
  end
end