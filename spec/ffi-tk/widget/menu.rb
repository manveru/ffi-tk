# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Menu do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::Menu.new
    instance.class.should == Tk::Menu
    instance.tk_parent.should == Tk.root
  end

  it 'coerces its widget-level options by declared type' do
    menu = Tk::Menu.new(tearoff: false)
    menu.cget(:tearoff).should == false
    menu.configure(tearoff: true)
    menu.cget(:tearoff).should == true

    # -type is fixed at creation; it is a keyword set (:symbol).
    menu.cget(:type).should == :normal

    menu.configure(selectcolor: '#ff0000', title: 'File')
    menu.cget(:selectcolor).should == '#ff0000'
    menu.cget(:title).should == 'File'
    # a script option with nothing bound is nil, never a flattened "".
    menu.cget(:postcommand).should.be.nil
  end

  it 'configure(option) returns that option\'s OptionDescription' do
    menu = Tk::Menu.new(tearoff: false)
    description = menu.configure(:tearoff)
    description.should.be.is_a? Tk::OptionDescription
    description.name.should == :tearoff
    description.value.should == false
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

  it 'round-trips entry options through entrycget/entryconfigure, coerced by type' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'Save', accelerator: 'Ctrl+S')

    menu.entrycget(0, :label).should == 'Save'
    menu.entrycget(0, :accelerator).should == 'Ctrl+S'
    # -columnbreak is a :boolean, coerced from Tk's "0"/"1" to false/true.
    menu.entrycget(0, :columnbreak).should == false
    # -underline is an :integer.
    menu.entrycget(0, :underline).should == -1

    menu.entryconfigure(0, label: 'Store')
    menu.entrycget(0, :label).should == 'Store'
  end

  it 'entryconfigure(option) returns that entry option\'s OptionDescription' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'Save')

    description = menu.entryconfigure(0, :label)
    description.should.be.is_a? Tk::OptionDescription
    description.name.should == :label
    description.value.should == 'Save'
  end

  it 'entryconfigure lists the entry\'s options as coerced OptionDescriptions' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'Save')

    descriptions = menu.entryconfigure(0)
    descriptions.should.be.is_a? Hash
    descriptions[:label].should.be.is_a? Tk::OptionDescription
    descriptions[:label].value.should == 'Save'
    # a script option with nothing bound is nil, never a flattened "".
    descriptions[:command].value.should.be.nil
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

  it 'inserts an entry by index and type without an options hash' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'last')
    menu.insert(0, :separator)
    menu.type(0).should == 'separator'
    menu.type(1).should == 'command'
  end

  it 'reports the x/y pixel position of an entry' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'entry')
    menu.xposition(0).should.be.is_a? Integer
    menu.yposition(0).should.be.is_a? Integer
  end

  it 'unposts a cascade submenu via postcascade' do
    menu = Tk::Menu.new(tearoff: false)
    sub = Tk::Menu.new(menu, tearoff: false)
    sub.add(:command, label: 'child')
    menu.add(:cascade, label: 'parent', menu: sub)
    -> { menu.postcascade(0) }.should.not.raise
  end

  it 'clones a menu' do
    menu = Tk::Menu.new(tearoff: false)
    menu.add(:command, label: 'orig')
    -> { menu.clone('.menuclone', :normal) }.should.not.raise
    Tk.execute('winfo', 'exists', '.menuclone').to_i.should == 1
  end
end
