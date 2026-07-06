# frozen_string_literal: true

require_relative '../../helper'

describe Tk::PanedWindow do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::PanedWindow.new
    instance.class.should == Tk::PanedWindow
    instance.tk_parent.should == Tk.root
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

  it 'configures panes and reads the options back' do
    pw = Tk::PanedWindow.new(orient: :horizontal)
    pane = Tk::Frame.new(pw)
    pane.configure(width: 100, height: 100)
    pw.add(pane)

    pw.paneconfigure(pane, minsize: 30, sticky: 'nsew')

    tcl_eq(pw.panecget(pane, :minsize), '30').should == true
    # Tk normalises the sticky string; assert on the set of sides, not the order.
    pw.panecget(pane, :sticky).to_s.chars.sort.should == %w[e n s w]
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
