# frozen_string_literal: true

require_relative '../../helper'

describe Tk::PanedWindow do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::PanedWindow.new
    instance.class.should == Tk::PanedWindow
    instance.tk_parent.should == Tk.root
  end

  it 'coerces its widget-level options by declared type' do
    pw = Tk::PanedWindow.new(orient: :vertical)
    pw.configure(opaqueresize: false, showhandle: true, sashrelief: :ridge, proxyrelief: :groove)

    pw.cget(:opaqueresize).should == false
    pw.cget(:showhandle).should == true
    pw.cget(:sashrelief).should == :ridge
    pw.cget(:proxyrelief).should == :groove
    pw.cget(:orient).should == :vertical
  end

  it 'keeps screen-distance options as their raw string' do
    pw = Tk::PanedWindow.new
    pw.configure(sashwidth: 6, handlesize: 10, width: 200, height: 150)

    # screen distances are kept lossless as strings, not converted to pixels.
    pw.cget(:sashwidth).should == '6'
    pw.cget(:handlesize).should == '10'
    pw.cget(:width).should == '200'
    pw.cget(:height).should == '150'
  end

  # Both the widget-level configure and per-pane paneconfigure (below) report
  # Tk's full describe-tuple as a typed OptionDescription (docs/adr/0001), not a
  # bare value.
  it 'configure(option) returns that option\'s OptionDescription' do
    pw = Tk::PanedWindow.new
    pw.configure(showhandle: true)
    description = pw.configure(:showhandle)
    description.should.be.is_a? Tk::OptionDescription
    description.name.should == :showhandle
    description.value.should == true
  end

  it 'adds panes, round-trips the pane list, and forgets them' do
    pw = Tk::PanedWindow.new(orient: :horizontal)
    left = Tk::Frame.new(pw)
    left.configure(width: 100, height: 100)
    right = Tk::Frame.new(pw)
    right.configure(width: 100, height: 100)

    pw.add(left, right)
    tcl_eq(pw.panes, [left.tk_pathname, right.tk_pathname]).should == true

    pw.forget(right)
    tcl_eq(pw.panes, [left.tk_pathname]).should == true
  end

  it 'configures panes and reads the options back, coerced by type' do
    pw = Tk::PanedWindow.new(orient: :horizontal)
    pane = Tk::Frame.new(pw)
    pane.configure(width: 100, height: 100)
    pw.add(pane)

    pw.paneconfigure(pane, minsize: 30, sticky: 'nsew', hide: false)

    # -minsize is a lossless screen-distance :string; -hide a :boolean,
    # -stretch a :symbol keyword set.
    pw.panecget(pane, :minsize).should == '30'
    # Tk normalises the sticky string; assert on the set of sides, not the order.
    pw.panecget(pane, :sticky).chars.sort.should == %w[e n s w]
    pw.panecget(pane, :hide).should == false
    pw.panecget(pane, :stretch).should == :last

    # Single-option query now returns the full describe-tuple as an
    # OptionDescription, not a bare value.
    description = pw.paneconfigure(pane, :minsize)
    description.should.be.is_a? Tk::OptionDescription
    description.name.should == :minsize
    description.value.should == '30'
  end

  it 'paneconfigure lists every pane option as a coerced OptionDescription' do
    pw = Tk::PanedWindow.new(orient: :horizontal)
    pane = Tk::Frame.new(pw)
    pw.add(pane)

    descriptions = pw.paneconfigure(pane)
    descriptions.should.be.is_a? Hash
    descriptions[:stretch].value.should == :last
    descriptions[:hide].value.should == false
  end

  it 'places sashes and proxies and identifies components when mapped' do
    pw = Tk::PanedWindow.new(orient: :horizontal)
    left = Tk::Frame.new(pw)
    left.configure(width: 100, height: 100)
    right = Tk::Frame.new(pw)
    right.configure(width: 100, height: 100)
    pw.add(left, right)
    pw.place(x: 0, y: 0, width: 400, height: 200)
    next unless skip_unless_mapped(pw)

    x, y = pw.sash_coord(0)
    x.should.be.kind_of(Integer)
    y.should.be.kind_of(Integer)

    # move the sash and read the new x back
    pw.sash_place(0, 150, y)
    Tk.execute('update')
    pw.sash_coord(0).first.should == 150

    # the proxy remembers where it was last placed
    pw.proxy_place(120, 0)
    pw.proxy_coord.first.should == 120
    pw.proxy_forget

    # a point on the sash identifies it by index and kind
    sx = pw.sash_coord(0).first
    index, kind = pw.identify(sx + 2, y + 5)
    index.should == 0
    tcl_eq(kind, 'sash').should == true
  end
end
