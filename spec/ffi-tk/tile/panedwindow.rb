# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Tile::PanedWindow do
  it 'initializes' do
    instance = Tk::Tile::PanedWindow.new
    instance.class.should == Tk::Tile::PanedWindow
    instance.tk_parent.should == Tk.root
  end

  it 'reads pane options as a coerced flat hash and single value' do
    pw = Tk::Tile::PanedWindow.new
    child = Tk::Tile::Frame.new(pw)
    pw.add(child, weight: 2)

    pw.pane(child).should == { weight: 2 }
    pw.pane(child, :weight).should == 2
  end

  it 'sets a pane option and reads it back' do
    pw = Tk::Tile::PanedWindow.new
    child = Tk::Tile::Frame.new(pw)
    pw.add(child, weight: 1)

    pw.pane(child, weight: 3)
    pw.pane(child, :weight).should == 3
  end

  it 'inserts a pane at a position and reads its option back' do
    pw = Tk::Tile::PanedWindow.new(orient: :horizontal)
    child = Tk::Tile::Frame.new(pw)
    pw.insert(:end, child, weight: 2)
    pw.pane(child, :weight).should == 2
  end

  it 'forgets a managed pane' do
    pw = Tk::Tile::PanedWindow.new(orient: :horizontal)
    child = Tk::Tile::Frame.new(pw)
    pw.add(child, weight: 1)
    pw.pane(child, :weight).should == 1 # managed

    pw.forget(child)
    -> { pw.pane(child, :weight) }.should.raise(RuntimeError) # no longer managed
  end

  it 'queries and sets a sash position' do
    pw = Tk::Tile::PanedWindow.new(orient: :horizontal)
    pw.pack
    left = Tk::Tile::Frame.new(pw, width: 100, height: 100)
    right = Tk::Tile::Frame.new(pw, width: 100, height: 100)
    pw.add(left, weight: 1)
    pw.add(right, weight: 1)
    next unless skip_unless_mapped(pw)

    pw.sashpos(0).should.be.is_a? Integer
    pw.sashpos(0, 60).should == 60
  end

  it 'identifies the sash under a point (empty off a sash)' do
    pw = Tk::Tile::PanedWindow.new(orient: :horizontal)
    pw.pack
    pw.add(Tk::Tile::Frame.new(pw, width: 100, height: 100), weight: 1)
    pw.add(Tk::Tile::Frame.new(pw, width: 100, height: 100), weight: 1)
    next unless skip_unless_mapped(pw)

    # a corner is never over a sash
    pw.identify(0, 0).to_s.should == ''
  end

  it 'does not expose classic-only subcommands ttk::panedwindow lacks' do
    pw = Tk::Tile::PanedWindow.new
    pw.respond_to?(:panecget).should == false
    pw.respond_to?(:paneconfigure).should == false
    pw.respond_to?(:sash_coord).should == false
    pw.respond_to?(:proxy_place).should == false
    -> { pw.panecget(0, :weight) }.should.raise(NoMethodError)
  end
end
