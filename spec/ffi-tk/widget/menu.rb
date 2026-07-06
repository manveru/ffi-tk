# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Menu do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::Menu.new
    instance.class.should == Tk::Menu
    instance.tk_parent.should == Tk.root
  end

  it 'adds entries of each type and reports their type back' do
    menu = Tk::Menu.new(tearoff: false)
    sub = Tk::Menu.new(menu)

    menu.add(:command, label: 'Run')
    menu.add(:checkbutton, label: 'Toggle')
    menu.add(:radiobutton, label: 'Pick')
    menu.add(:separator)
    menu.add(:cascade, label: 'More', menu: sub)

    menu.index(:end).should == 4
    tcl_eq(menu.type(0), 'command').should == true
    tcl_eq(menu.type(1), 'checkbutton').should == true
    tcl_eq(menu.type(2), 'radiobutton').should == true
    tcl_eq(menu.type(3), 'separator').should == true
    tcl_eq(menu.type(4), 'cascade').should == true
  end

  it 'round-trips entry options through entrycget/entryconfigure' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'Save', accelerator: 'Ctrl+S')

    menu.entrycget(0, :label).should == 'Save'
    menu.entrycget(0, :accelerator).should == 'Ctrl+S'

    menu.entryconfigure(0, label: 'Store')
    menu.entrycget(0, :label).should == 'Store'
  end

  it 'inserts an entry before an existing one' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'second')
    menu.insert(0, :command, label: 'first')

    menu.index(:end).should == 1
    menu.entrycget(0, :label).should == 'first'
    menu.entrycget(1, :label).should == 'second'
  end

  it 'runs the Ruby callback of a command entry when invoked' do
    menu = Tk::Menu.new(tearoff: false)
    ran = []
    menu.add(:command, label: 'Go', command: proc { ran << :go })

    # invoke returns the entry command's result — here the callback's own
    # return value, marshalled back through the Tcl result.
    menu.invoke(0).should == ['go']
    ran.should == [:go]
  end

  it 'registers a command inserted with a callback so it can be cleaned up' do
    menu = Tk::Menu.new(tearoff: false)
    ran = []
    menu.insert(0, :command, label: 'Ins', command: proc { ran << :ins })

    menu.invoke(0)
    ran.should == [:ins]
    # The callback is tracked on the widget (like #add), not leaked globally.
    menu.instance_variable_get(:@commands).keys.should == [:command]
  end

  it 'deletes a range of entries' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'a')
    menu.add(:command, label: 'b')
    menu.add(:command, label: 'c')
    menu.index(:end).should == 2

    menu.delete(1, 2)
    menu.index(:end).should == 0
    menu.entrycget(0, :label).should == 'a'
  end

  it 'activates an entry and reports it as the active index' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'a')
    menu.add(:command, label: 'b')

    menu.activate(1)
    tcl_eq(menu.index(:active), 1).should == true
  end

  it 'posts and unposts quietly' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'a')

    menu.post(60, 60).should.nil?
    Tk.execute('update')
    menu.unpost.should.nil?
  end
end
