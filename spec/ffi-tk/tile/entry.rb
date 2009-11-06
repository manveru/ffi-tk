require_relative '../../helper'

Tk.init

describe Tk::Tile::Entry do
  Entry = Tk::Tile::Entry
  @entry = Entry.new('.')

  it 'Returns the current value of the configuration option given' do
    Tk::Tile::Style.theme_use 'alt'

    @entry.cget(:width              ).should >= 0
    @entry.cget(:exportselection    ).should == true
    #@entry.cget(:font               ).should == "TkTextFont"
    @entry.cget(:invalidcommand     ).should == nil
    @entry.cget(:justify            ).should == :left
    @entry.cget(:validate           ).should == :none
    @entry.cget(:validatecommand    ).should == nil
    @entry.cget(:width              ).should == 20
    @entry.cget(:xscrollcommand     ).should == nil

    @entry.cget(:takefocus          ).should == false
    @entry.cget(:textvariable       ).should == nil # ""
  end

  it 'sets ttk-state independent of tk-state' do
    @entry.cget(:state).should == ['normal']
    @entry.configure(state: 'normal').should == true
    @entry.cget(:state).should == ['normal']

    @entry.state(:active).should == true
    @entry.state.should == ['active']

    @entry.state(:disabled).should == true
    @entry.state.should == ['active','disabled']

    @entry.cget(:state).should == ['normal']
  end

  it 'sets ttk-state independent of tk-state (or not?)' do
    @entry.cget(:state).should == ['normal']
    @entry.configure(state: 'disabled').should == true
    @entry.cget(:state).should == ['disabled']

    @entry.state(:active).should == true
    @entry.state.should == ['active','disabled']

    @entry.state(:disabled).should == true
    @entry.state.should == ['active','disabled']

    @entry.cget(:state).should == ['disabled']
  end

  #NOTE fails on 'bacon spec/tile/*' but passes with 'ruby __FILE__'
  #it 'Configure the current value of cursor' do
  #  @entry.cget(:cursor             ).should == nil #"xterm"
  #  @entry.configure(cursor: 'xterm').should == true
  #  @entry.cget(:cursor             ).should == 'xterm'
  #end
end

