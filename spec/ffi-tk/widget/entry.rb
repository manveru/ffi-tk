# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Entry do
  entry = Tk::Entry.new

  cget_options = {
    background: ['systemWindowBody', '#ffffff', '#282828'],
    bd: [2, 1],
    bg: ['systemWindowBody', '#ffffff', '#282828'],
    borderwidth: [2, 1],
    cursor: ['xterm'],
    disabledbackground: ['systemWindowBody', '#d9d9d9'],
    disabledforeground: ['#a3a3a3'],
    exportselection: [true],
    fg: ['Black', '#000000', '#ebdbb2'],
    font: ['TkTextFont'],
    foreground: ['Black', '#000000', '#ebdbb2'],
    highlightbackground: ['systemWindowBody', '#d9d9d9'],
    highlightcolor: ['Black', '#000000'],
    highlightthickness: [3, 1],
    insertbackground: ['Black', '#000000'],
    insertborderwidth: [0],
    insertofftime: [300],
    insertontime: [600],
    insertwidth: [1, 2],
    invalidcommand: [nil],
    invcmd: [nil],
    justify: [:left],
    readonlybackground: ['systemWindowBody', '#d9d9d9'],
    relief: [:sunken],
    selectbackground: ['systemHighlight', '#c3c3c3'],
    selectborderwidth: [1, 0],
    selectforeground: [nil, '#000000'],
    show: [nil],
    state: [['normal']],
    takefocus: [false],
    textvariable: [nil],
    validate: [:none],
    validatecommand: [nil],
    vcmd: [nil],
    width: [20],
    xscrollcommand: [nil]
  }

  describe 'getting options via cget' do
    cget_options.each do |key, values|
      it "returns a member of #{values.inspect} for -#{key}" do
        values.should.include entry.cget(key)
      end
    end
  end

  it 'configures a single option' do
    entry.configure(validate: :focus)
    entry.cget(:validate).should == :focus
    entry.configure(validate: :none)
    entry.cget(:validate).should == :none
  end

  it 'configures more options at once' do
    entry.configure(justify: :right, validate: :focus)
    entry.cget(:validate).should == :focus
    entry.cget(:justify).should == :right

    entry.configure(justify: :left, validate: :none)
    entry.cget(:validate).should == :none
    entry.cget(:justify).should == :left
  end

  it "returns the entry's string" do
    entry.get.should == ''
  end

  it 'inserts text at index' do
    entry.insert(:end, 'Hello, World!')
    entry.get.should == 'Hello, World!'
  end

  it 'returns a list of four numbers describing the bounding box of the character given by index' do
    index_bbox = entry.bbox(0)
    index_bbox.should.be.is_a? Array
    index_bbox.size.should == 4
  end

  it 'deletes character at index' do
    entry.delete(5)
    entry.get.should == 'Hello World!'
  end

  it 'deletes character between indices' do
    entry.delete(5, 11)
    entry.get.should == 'Hello!'
  end

  it 'Puts the insertion cursor just before the character given by index' do
    entry.icursor(5)
    entry.insert(:insert, ', World')
    entry.get.should == 'Hello, World!'
  end

  it 'Returns the numerical index corresponding to index' do
    entry.index(:insert).should == 12
  end

  it 'Insert the string just before the character indicated by index' do
    entry.insert(0, 'OHAI ')
    entry.get.should == 'OHAI Hello, World!'
  end

  it 'uses the scan commands' do
    lambda do
      entry.scan_mark(0)
      entry.scan_dragto(10)
    end.should.not.raise
  end

  it 'Returns whether a selection is present' do
    entry.selection_present.should == false
  end

  it 'adjusts the selection' do
    entry.selection_adjust(0)
    entry.index('sel.first').should == 0
    entry.selection_adjust(5)
    entry.index('sel.last').should == 5
  end

  it 'Clears the selection' do
    entry.selection_present.should == true
    entry.selection_clear
    entry.selection_present.should == false
  end

  it 'Selects the characters at start ending with the one just before end' do
    entry.selection_range(1, 4)
    entry.index('sel.first').should == 1
    entry.index('sel.last').should == 4
  end

  it 'Adjusts selection with the from and to commands' do
    entry.selection_from(2)
    entry.selection_to(5)
    entry.index('sel.first').should == 2
    entry.index('sel.last').should == 5
  end

  it 'validates the entry without validation command' do
    entry.validate.should == true
  end

  it 'validates the entry with validation command' do
    entry.configure validatecommand: ->(*_args) { true }
    entry.validate.should == true

    entry.configure validatecommand: ->(*_args) { false }
    entry.validate.should == false
  end
end

# puts
# entry.configure.map{|c| c.first[1..-1] }.each{|k,v|
#   puts "entry.cget(%-20p).should == %p" % [k.to_sym, entry.cget(k)]
# }
