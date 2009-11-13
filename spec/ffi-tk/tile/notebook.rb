require_relative '../../helper'

Tk.init

describe Tk::Tile::Notebook do
  it 'initializes' do
    instance = Tk::Tile::Notebook.new
    instance.class.should == Tk::Tile::Notebook
    instance.parent.should == Tk.root
  end

  it 'adds a new tab' do
    f0 = Tk::Tile::Frame.new
    nb = Tk::Tile::Notebook.new

    nb.add( f0, text: 'first tab' ).should == true
  end

  it 'selects the specified tab' do
    f0 = Tk::Tile::Frame.new
    f1 = Tk::Tile::Frame.new

    nb = Tk::Tile::Notebook.new
    nb.add( f0, text: 'first tab' ).should == true
    nb.add( f1, text: 'second tab' ).should == true

    nb.select(f1).should == f1.tk_pathname
    nb.select(f0).should == f0.tk_pathname
  end

  it 'return index of tabs' do
    f0 = Tk::Tile::Frame.new
    f1 = Tk::Tile::Frame.new

    nb = Tk::Tile::Notebook.new
    nb.add( f0, text: 'first tab' ).should == true
    nb.add( f1, text: 'second tab' ).should == true

    nb.index(f1).should == 1
    nb.index(f0).should == 0
    nb.index('end').should == 2 # total number of tabs
    nb.index('current').should == 0
  end

  it 'return a list of managed tabs' do
    f2 = Tk::Tile::Frame.new
    nb = Tk::Tile::Notebook.new

    nb.tabs.should == []
    nb.add( f2, text: 'first tab' ).should == true
    nb.tabs.should == [ f2.tk_pathname ]
  end

  it 'inserts a new tab at position' do
    f0 = Tk::Tile::Frame.new
    f1 = Tk::Tile::Frame.new
    nb = Tk::Tile::Notebook.new

    nb.add( f0, text: 'first tab' ).should == true
    nb.insert( 0, f1, text: 'first tab' ).should == true

    nb.tabs.should == [ f1.tk_pathname, f0.tk_pathname ]
  end

  it 'set tab options' do
    f2 = Tk::Tile::Frame.new
    nb = Tk::Tile::Notebook.new

    nb.add(f2, text: 'first tab' ).should == true

    nb.tab(f2, state: :disabled ).should == true
    nb.tab(f2).should.include 'disabled'
  end

  it 'forgets the specified tab' do
    f2 = Tk::Tile::Frame.new
    nb = Tk::Tile::Notebook.new

    nb.add( f2, text: 'first tab' ).should == true
    nb.tabs.should == [ f2.tk_pathname ]

    nb.forget(f2).should == true
    nb.tabs.should == [ ]
  end

  it 'hides a specified tab' do
    f2 = Tk::Tile::Frame.new
    nb = Tk::Tile::Notebook.new

    nb.add( f2, text: 'first tab' ).should == true

    nb.hide(f2).should == true
    nb.tabs.should == [ f2.tk_pathname ]
  end

  it 'enables traversal' do
    nb = Tk::Tile::Notebook.new
    nb.enable_traversal.should == true

    Tk::Tile::Notebook.enable_traversal(nb).should == true
  end
end

