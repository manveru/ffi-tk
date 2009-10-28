require 'bacon'
Bacon.summary_at_exit

require_relative '../../lib/ffi-tk'

Tk.init

describe Tk::Text do
  @text = Tk::Text.new('.')

  it 'inserts text at a position' do
    lambda{ @text.insert('end', 'Hello, World!') }.should.not.raise
  end

  it 'gets the text at index' do
    @text.get('end').should == ''
    @text.get('1.0').should == 'H'
  end

  it 'gets text between two indices' do
    @text.get('1.0', 'end').should == "Hello, World!\n"
  end

  it 'configures a single option' do
    @text.cget(:wrap).should == :char
    @text.configure(wrap: :word)
    @text.cget(:wrap).should == :word
  end

  it 'configures more options at once' do
    @text.cget(:width).should == 80
    @text.cget(:height).should == 24
    @text.configure(width: 20, height: 20)
    @text.cget(:width).should == 20
    @text.cget(:height).should == 20
  end

  it 'compares two indices' do
    @text.compare('1.0', '==', '1.1').should == false
    @text.compare('1.0', '>',  '1.1').should == false
    @text.compare('1.0', '<',  '1.1').should == true
    @text.compare('1.0', '!=', '1.1').should == true
    @text.compare('1.0', '<=', '1.1').should == true
    @text.compare('1.0', '>=', '1.1').should == false
  end

  it 'counts chars' do
    @text.count(:chars, 1.0, :end).should == 14
  end

  it 'counts displaychars' do
    @text.count(:displaychars, 1.0, :end).should == 14
  end

  it 'counts displayindices' do
    @text.count(:displayindices, 1.0, :end).should == 14
  end

  it 'counts displaylines' do
    @text.count(:displaylines, 1.0, :end).should == 13
  end

  it 'counts indices' do
    @text.count(:indices, 1.0, :end).should == 14
  end

  it 'counts lines' do
    @text.count(:lines, 1.0, :end).should == 1
  end

  it 'counts xpixels' do
    @text.count(:xpixels, 1.0, :end).should == 0
  end

  it 'counts ypixels' do
    @text.count(:ypixels, 1.0, :end).should == 195
  end

  should 'not be in debug mode' do
    @text.should.not.be.debug
  end

  it 'deletes at index' do
    @text.delete(1.0)
    @text.get(1.0, 'end').should == "ello, World!\n"
  end

  it 'deletes between indices' do
    @text.delete(1.2, 1.5)
    @text.get(1.0, 'end').should == "el World!\n"
  end

  it 'gives line info' do
    @text.dlineinfo(1.0).should == [3, 3, 6, 1, 12]
  end
end