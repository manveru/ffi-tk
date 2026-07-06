# frozen_string_literal: true

require_relative '../../helper'

Tk.init

# Scrollable is a mixin (xview/yview family). It is exercised here through a
# Listbox, which includes it and scrolls in both axes when its content is larger
# than the viewport.
describe Tk::Scrollable do
  before { reset_root! }

  def scrollable_listbox
    listbox = Tk::Listbox.new('.')
    listbox.place(x: 0, y: 0, width: 120, height: 60)
    50.times { |i| listbox.insert(:end, "item-#{i}-with-a-long-horizontal-tail-xxxxxxxxxx") }
    Tk.execute('update')
    listbox
  end

  it 'reads the vertical view as two fractions between 0 and 1' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    view = listbox.yview
    view.size.should == 2
    view.all? { |f| f.is_a?(Float) }.should == true
    view[0].should == 0.0
    view[1].should > 0.0
    view[1].should <= 1.0
  end

  it 'scrolls the vertical view down with yview_moveto' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    listbox.yview(0)
    Tk.execute('update')
    before = listbox.yview[0]

    listbox.yview_moveto(0.5)
    Tk.execute('update')
    listbox.yview[0].should > before
  end

  it 'repositions the top of the view with yview(index)' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    listbox.yview(10)
    Tk.execute('update')
    listbox.yview[0].should > 0.0

    listbox.yview(0)
    Tk.execute('update')
    listbox.yview[0].should == 0.0
  end

  it 'moves the vertical view by units and pages, respecting direction' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    listbox.yview(0)
    Tk.execute('update')

    listbox.yview_scroll(3, :units)
    Tk.execute('update')
    after_units = listbox.yview[0]
    after_units.should > 0.0

    listbox.yview_scroll(1, :pages)
    Tk.execute('update')
    listbox.yview[0].should > after_units

    listbox.yview_scroll(-2, :units)
    Tk.execute('update')
    listbox.yview[0].should < after_units + 1.0 # moved back up from the page position
  end

  it 'reads the horizontal view as two fractions between 0 and 1' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    view = listbox.xview
    view.size.should == 2
    view.all? { |f| f.is_a?(Float) }.should == true
    view[0].should == 0.0
    view[1].should > 0.0
    view[1].should < 1.0
  end

  it 'scrolls the horizontal view right with xview_moveto and xview_scroll' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    listbox.xview_moveto(0.0)
    Tk.execute('update')

    listbox.xview_moveto(0.3)
    Tk.execute('update')
    after_moveto = listbox.xview[0]
    after_moveto.should > 0.0

    listbox.xview_scroll(2, :units)
    Tk.execute('update')
    listbox.xview[0].should > after_moveto

    listbox.xview_scroll(-2, :units)
    Tk.execute('update')
    listbox.xview[0].should < listbox.xview[1]
  end

  it 'repositions the horizontal view with xview(index)' do
    listbox = scrollable_listbox
    next unless skip_unless_mapped(listbox)

    listbox.xview(5)
    Tk.execute('update')
    listbox.xview[0].should > 0.0

    listbox.xview(0)
    Tk.execute('update')
    listbox.xview[0].should == 0.0
  end
end
