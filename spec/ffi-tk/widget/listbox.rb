# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Listbox do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::Listbox.new
    instance.class.should == Tk::Listbox
    instance.tk_parent.should == Tk.root
  end

  it 'Make sure we get contents of the list' do
    list = Tk::Listbox.new
    list.insert 0, 'first line'
    list.get(0).should == 'first line'
    list.insert 1, 'second line'
    list.get(1).should == 'second line'
    list.get(0, 1).should == ['first line', 'second line']
    list.value.should == ['first line', 'second line']
  end

  it 'inserts, sizes, indexes and deletes elements' do
    list = Tk::Listbox.new
    list.insert(:end, 'a', 'b', 'c', 'd')

    list.size.should == 4
    list.index(:end).should == 4
    list.get(0, :end).should == %w[a b c d]

    list.delete(1, 2)
    list.size.should == 2
    list.get(0, :end).should == %w[a d]
  end

  it 'tracks selection state across set/includes/anchor/clear' do
    list = Tk::Listbox.new
    list.insert(:end, 'a', 'b', 'c', 'd')

    list.selection_set(1, 2)
    list.curselection.should == [1, 2]
    tcl_eq(list.selection_includes(1), 1).should == true
    tcl_eq(list.selection_includes(0), 0).should == true

    list.selection_anchor(3)
    tcl_eq(list.index(:anchor), 3).should == true

    list.selection_clear(1, 2)
    list.curselection.should == []
  end

  it 'activates an element and exposes it via index(:active)' do
    list = Tk::Listbox.new
    list.insert(:end, 'a', 'b', 'c')

    list.activate(2)
    tcl_eq(list.index(:active), 2).should == true
  end

  it 'round-trips item options through itemcget/itemconfigure' do
    list = Tk::Listbox.new
    list.insert(:end, 'a')

    list.itemcget(0, :background).should.nil?
    list.itemconfigure(0, background: 'red')
    list.itemcget(0, :background).should == 'red'
  end

  it 'reports the nearest element and a mapped element bbox' do
    list = Tk::Listbox.new
    list.insert(:end, 'a', 'b', 'c')
    list.pack
    next unless skip_unless_mapped(list)

    list.nearest(0).should == 0

    box = list.bbox(0)
    box.size.should == 4
    box.all? { |n| n.is_a?(Integer) }.should == true
    box[2].should > 0 # width
    box[3].should > 0 # height
  end

  it 'round-trips the view fraction through yview (shared Scrollable)' do
    list = Tk::Listbox.new(height: 3)
    list.pack
    50.times { |i| list.insert(:end, "item#{i}") }
    Tk.execute('update')

    top = list.yview
    top.size.should == 2
    top[0].should == 0.0
    top[1].should < 1.0

    list.yview_moveto(0.5)
    Tk.execute('update')
    mid = list.yview
    mid[0].should > 0.0
    mid[0].should > top[0]
  end
end
