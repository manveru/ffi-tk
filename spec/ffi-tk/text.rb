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

  it 'gets all possible options with cget' do
    @text.cget(:autoseparators).should == true
    @text.cget(:background).should == '#ffffff'
    @text.cget(:bd).should == 1
    @text.cget(:bg).should == '#ffffff'
    @text.cget(:blockcursor).should == false
    @text.cget(:borderwidth).should == 1
    @text.cget(:cursor).should == 'xterm'
    @text.cget(:endline).should == 0
    @text.cget(:exportselection).should == true
    @text.cget(:fg).should == '#000000'
    @text.cget(:font).should == 'TkFixedFont'
    @text.cget(:foreground).should == '#000000'
    @text.cget(:height).should == 24
    @text.cget(:highlightbackground).should == '#d9d9d9'
    @text.cget(:highlightcolor).should == '#000000'
    @text.cget(:highlightthickness).should == 1
    @text.cget(:inactiveselectbackground).should == '#c3c3c3'
    @text.cget(:insertbackground).should == '#000000'
    @text.cget(:insertborderwidth).should == 0
    @text.cget(:insertofftime).should == 300
    @text.cget(:insertontime).should == 600
    @text.cget(:insertwidth).should == 2
    @text.cget(:maxundo).should == 0
    @text.cget(:padx).should == 1
    @text.cget(:pady).should == 1
    @text.cget(:relief).should == :sunken
    @text.cget(:selectbackground).should == '#c3c3c3'
    @text.cget(:selectborderwidth).should == 0
    @text.cget(:selectforeground).should == '#000000'
    @text.cget(:setgrid).should == false
    @text.cget(:spacing1).should == 0
    @text.cget(:spacing2).should == 0
    @text.cget(:spacing3).should == 0
    @text.cget(:startline).should == 0
    @text.cget(:state).should == :normal
    @text.cget(:tabs).should == ''
    @text.cget(:tabstyle).should == :tabular
    @text.cget(:takefocus).should == false
    @text.cget(:undo).should == false
    @text.cget(:width).should == 80
    @text.cget(:wrap).should == :char

    # TODO: they should be more... useful?
    @text.cget(:xscrollcommand).should == :''
    @text.cget(:yscrollcommand).should == :''
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

  it 'inserts string with taglist' do
    @text.insert(1.0, 'H', 'start')
    @text.get(1.0, :end).should == "Hel World!\n"
  end

  it 'queries mark gravity' do
    @text.mark_gravity(:insert).should == :right
  end

  it 'changes mark gravity' do
    @text.mark_gravity(:insert, :left)
    @text.mark_gravity(:insert).should == :left
    @text.mark_gravity(:insert, :right)
  end

  it 'lists mark names' do
    @text.mark_names.sort.should == [:current, :insert]
  end

  it 'answers with the next mark after index' do
    @text.mark_next('1.0').should == :insert
    @text.mark_next(:insert).should == :current
    @text.mark_next(:current).should.be.nil
  end

  it 'ansewrs with the previous mark before index' do
    @text.mark_previous(:end).should == :current
    @text.mark_previous(:current).should == :insert
    @text.mark_previous(:insert).should.be.nil
  end

  it 'sets a mark' do
    @text.mark_set('foo', '1.3').should.be.nil
    @text.mark_names.sort.should == [:current, :foo, :insert]
  end

  it 'unsets a mark' do
    @text.mark_unset('foo').should.be.nil
    @text.mark_names.sort.should == [:current, :insert]
  end

  it 'creates a peer' do
    @peer = @text.peer_create
    @peer.tk_pathname.should == '.tk::text1.tk::text::peer1'
  end

  it 'lists the peer' do
    @text.peer_names.should == ['.tk::text1.tk::text::peer1']
  end

  it 'destroys the peer' do
    @peer.destroy
    @text.peer_names.should == []
  end

  # TODO: image handling
end