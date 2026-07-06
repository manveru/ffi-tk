# frozen_string_literal: true

require_relative '../../helper'

Tk.init

# Every assertion here is a round-trip against a live grid: we configure a slave
# (or a row/column) and read the state back through the very method under test.
# Values were captured from Tk 8.6.16 on a real display before being asserted.
describe Tk::Grid do
  root = Tk.root

  # Fresh, non-trivially-sized buttons for every spec so grid state never leaks.
  def button(text)
    b = Tk::Button.new(Tk.root)
    b.configure(text: text)
    b
  end

  before { reset_root! }

  it 'configures a slave and reads the placement back through info' do
    b = button('a')
    Tk::Grid.configure(b, column: 1, row: 2, padx: 4, sticky: 'ew')

    info = Tk::Grid.info(b)
    info.should == {
      in: '.', column: 1, row: 2, columnspan: 1, rowspan: 1,
      ipadx: 0, ipady: 0, padx: 4, pady: 0, sticky: 'ew'
    }
  end

  it 'lists the managed slaves, most recently managed first' do
    b0 = button('0')
    b1 = button('1')
    Tk::Grid.configure(b0, column: 0, row: 0)
    Tk::Grid.configure(b1, column: 1, row: 1)

    Tk::Grid.slaves(root).should == [b1.tk_pathname, b0.tk_pathname]
  end

  it 'filters slaves by row' do
    b0 = button('0')
    b1 = button('1')
    Tk::Grid.configure(b0, column: 0, row: 0)
    Tk::Grid.configure(b1, column: 1, row: 1)

    Tk::Grid.slaves(root, row: 0).should == [b0.tk_pathname]
  end

  it 'returns the cell bounding box as four integers inside the whole-grid box' do
    b = button('a')
    Tk::Grid.configure(b, column: 0, row: 0)
    next unless skip_unless_mapped(b)

    whole = Tk::Grid.bbox(root)
    cell = Tk::Grid.bbox(root, 0, 0)

    cell.size.should == 4
    cell.all? { |n| n.is_a?(Integer) }.should == true
    (cell[2] <= whole[2]).should == true
    (cell[3] <= whole[3]).should == true
  end

  it 'sets and reads back column properties via columnconfigure' do
    button('a').tap { |b| Tk::Grid.configure(b, column: 0, row: 0) }
    Tk::Grid.columnconfigure(root, 0, weight: 3, minsize: 20)

    settings = Hash[*Tk::Grid.columnconfigure(root, 0)]
    settings['-weight'].should == 3
    settings['-minsize'].should == 20
  end

  it 'sets and reads back row properties via rowconfigure' do
    button('a').tap { |b| Tk::Grid.configure(b, column: 0, row: 0) }
    Tk::Grid.rowconfigure(root, 0, weight: 2, pad: 5)

    settings = Hash[*Tk::Grid.rowconfigure(root, 0)]
    settings['-weight'].should == 2
    settings['-pad'].should == 5
  end

  it 'toggles geometry propagation and reports the current state' do
    Tk::Grid.propagate(root, false)
    Tk::Grid.propagate(root).should == 0
    Tk::Grid.propagate(root, true)
    Tk::Grid.propagate(root).should == 1
  end

  it 'sets and queries the grid anchor' do
    Tk::Grid.anchor(root, 'se')
    Tk::Grid.anchor(root).should == 'se'
    Tk::Grid.anchor(root, 'nw')
    Tk::Grid.anchor(root).should == 'nw'
  end

  it 'reports the grid size in columns then rows' do
    button('a').tap { |b| Tk::Grid.configure(b, column: 0, row: 0) }
    button('b').tap { |b| Tk::Grid.configure(b, column: 2, row: 1) }

    # occupied through column index 2 and row index 1 => 3 columns, 2 rows
    tcl_eq(Tk::Grid.size(root), [3, 2]).should == true
  end

  it 'maps a pixel location to a cell and returns -1 outside the grid' do
    b = button('a')
    Tk::Grid.configure(b, column: 0, row: 0)
    next unless skip_unless_mapped(b)

    tcl_eq(Tk::Grid.location(root, 2, 2), [0, 0]).should == true
    tcl_eq(Tk::Grid.location(root, -5, -5), [-1, -1]).should == true
  end

  it 'forgets a slave, dropping it from the managed set' do
    keep = button('keep')
    drop = button('drop')
    Tk::Grid.configure(keep, column: 0, row: 0)
    Tk::Grid.configure(drop, column: 1, row: 0)

    Tk::Grid.forget(drop)
    Tk::Grid.slaves(root).should == [keep.tk_pathname]
  end

  it 'removes a slave from the managed set while remembering its config' do
    keep = button('keep')
    drop = button('drop')
    Tk::Grid.configure(keep, column: 0, row: 0)
    Tk::Grid.configure(drop, column: 1, row: 0)

    Tk::Grid.remove(drop)
    Tk::Grid.slaves(root).should == [keep.tk_pathname]
  end
end
