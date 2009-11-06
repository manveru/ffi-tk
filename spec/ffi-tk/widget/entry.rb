require_relative '../../helper'

describe Tk::Entry do
  @entry = Tk::Entry.new

  it "returns the entry's string" do
    @entry.get.should == ''
  end

  it 'inserts text at index' do
    @entry.insert(:end, 'Hello, World!')
    @entry.get.should == 'Hello, World!'
  end

  it 'returns a list of four numbers describing the bounding box of the character given by index' do
    @entry.bbox(0).should == [3, -7, 6, 15]
  end

  it 'Returns the current value of the configuration option given' do
    @entry.cget(:background         ).should == "#ffffff"
    @entry.cget(:bd                 ).should == 1
    @entry.cget(:bg                 ).should == "#ffffff"
    @entry.cget(:borderwidth        ).should == 1
    @entry.cget(:cursor             ).should == "xterm"
    @entry.cget(:disabledbackground ).should == "#d9d9d9"
    @entry.cget(:disabledforeground ).should == "#a3a3a3"
    @entry.cget(:exportselection    ).should == true
    @entry.cget(:fg                 ).should == "#000000"
    @entry.cget(:font               ).should == "TkTextFont"
    @entry.cget(:foreground         ).should == "#000000"
    @entry.cget(:highlightbackground).should == "#d9d9d9"
    @entry.cget(:highlightcolor     ).should == "#000000"
    @entry.cget(:highlightthickness ).should == 1
    @entry.cget(:insertbackground   ).should == "#000000"
    @entry.cget(:insertborderwidth  ).should == 0
    @entry.cget(:insertofftime      ).should == 300
    @entry.cget(:insertontime       ).should == 600
    @entry.cget(:insertwidth        ).should == 2
    @entry.cget(:invalidcommand     ).should == nil
    @entry.cget(:invcmd             ).should == nil
    @entry.cget(:justify            ).should == :left
    @entry.cget(:readonlybackground ).should == "#d9d9d9"
    @entry.cget(:relief             ).should == :sunken
    @entry.cget(:selectbackground   ).should == "#c3c3c3"
    @entry.cget(:selectborderwidth  ).should == 0
    @entry.cget(:selectforeground   ).should == "#000000"
    @entry.cget(:show               ).should == nil
    @entry.cget(:state              ).should == ['normal']
    @entry.cget(:takefocus          ).should == false
    @entry.cget(:textvariable       ).should == nil
    @entry.cget(:validate           ).should == :none
    @entry.cget(:validatecommand    ).should == nil
    @entry.cget(:vcmd               ).should == nil
    @entry.cget(:width              ).should == 20
    @entry.cget(:xscrollcommand     ).should == nil
  end

  it 'configures a single option' do
    @entry.configure(validate: :focus)
    @entry.cget(:validate).should == :focus
    @entry.configure(validate: :none)
    @entry.cget(:validate).should == :none
  end

  it 'configures more options at once' do
    @entry.configure(justify: :right, validate: :focus)
    @entry.cget(:validate).should == :focus
    @entry.cget(:justify).should == :right

    @entry.configure(justify: :left, validate: :none)
    @entry.cget(:validate).should == :none
    @entry.cget(:justify).should == :left
  end

  it "deletes character at index" do
    @entry.delete(5)
    @entry.get.should == "Hello World!"
  end

  it "deletes character between indices" do
    @entry.delete(5, 11)
    @entry.get.should == "Hello!"
  end

  it "Puts the insertion cursor just before the character given by index" do
    @entry.icursor(5)
    @entry.insert(:insert, ", World")
    @entry.get.should == "Hello, World!"
  end

  it "Returns the numerical index corresponding to index" do
    @entry.index(:insert).should == 12
  end

  it "Insert the string just before the character indicated by index" do
    @entry.insert(0, 'OHAI ')
    @entry.get.should == 'OHAI Hello, World!'
  end

  it 'uses the scan commands' do
    lambda{
      @entry.scan_mark(0)
      @entry.scan_dragto(10)
    }.should.not.raise
  end

  it 'Returns whether a selection is present' do
    @entry.selection_present.should == false
  end

  it 'adjusts the selection' do
    @entry.selection_adjust(0)
    @entry.index('sel.first').should == 0
    @entry.selection_adjust(5)
    @entry.index('sel.last').should == 5
  end

  it 'Clears the selection' do
    @entry.selection_present.should == true
    @entry.selection_clear
    @entry.selection_present.should == false
  end

  it 'Selects the characters at start ending with the one just before end' do
    @entry.selection_range(1, 4)
    @entry.index('sel.first').should == 1
    @entry.index('sel.last').should == 4
  end

  it 'Adjusts selection with the from and to commands' do
    @entry.selection_from(2)
    @entry.selection_to(5)
    @entry.index('sel.first').should == 2
    @entry.index('sel.last').should == 5
  end

  it 'validates the entry without validation command' do
    @entry.validate.should == true
  end

  it 'validates the entry with validation command' do
    @entry.configure validatecommand: lambda{|*args| true }
    @entry.validate.should == true

    @entry.configure validatecommand: lambda{|*args| false }
    @entry.validate.should == false
  end
end

# puts
# @entry.configure.map{|c| c.first[1..-1] }.each{|k,v|
#   puts "@entry.cget(%-20p).should == %p" % [k.to_sym, @entry.cget(k)]
# }