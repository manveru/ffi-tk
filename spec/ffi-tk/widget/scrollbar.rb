# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Scrollbar do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::Scrollbar.new
    instance.class.should == Tk::Scrollbar
    instance.tk_parent.should == Tk.root
  end

  it 'reports -width as a screen-distance string and -activerelief as a symbol' do
    bar = Tk::Scrollbar.new
    bar.configure(width: 20)
    bar.cget(:width).should == '20'
    bar.cget(:activerelief).should == :raised
  end

  it 'round-trips the visible fractions through set/get' do
    bar = Tk::Scrollbar.new(orient: :vertical)
    bar.set(0.2, 0.6)

    first, last = bar.get
    first.should.be.close(0.2, 0.0001)
    last.should.be.close(0.6, 0.0001)
  end

  it 'reports the active element, nil when none is active' do
    bar = Tk::Scrollbar.new(orient: :vertical)

    bar.activate.should.nil?
    bar.activate(:slider)
    tcl_eq(bar.activate, 'slider').should == true
  end

  it 'scales delta linearly with pixel distance' do
    bar = Tk::Scrollbar.new(orient: :vertical)
    # place with an explicit size so the trough geometry is deterministic,
    # independent of the root window's (sticky) history across specs.
    bar.place(x: 0, y: 0, width: 18, height: 300)
    next unless skip_unless_mapped(bar)

    one = bar.delta(0, 10)
    two = bar.delta(0, 20)
    one.should.be.kind_of(Float)
    two.should.be.close(2 * one, 0.0001)
  end

  it 'maps trough points to fractions' do
    bar = Tk::Scrollbar.new(orient: :vertical)
    bar.place(x: 0, y: 0, width: 18, height: 300)
    next unless skip_unless_mapped(bar)

    height = bar.winfo_height
    bar.fraction(0, 0).should == 0.0
    bar.fraction(0, height).should == 1.0
    bar.fraction(0, height / 2).should.be.close(0.5, 0.05)
  end

  it 'identifies the element under a trough point' do
    bar = Tk::Scrollbar.new(orient: :vertical)
    bar.place(x: 0, y: 0, width: 18, height: 300)
    bar.set(0.4, 0.6) # park the slider across the middle
    next unless skip_unless_mapped(bar)

    height = bar.winfo_height
    tcl_eq(bar.identify(5, 2), 'arrow1').should == true
    tcl_eq(bar.identify(5, height - 2), 'arrow2').should == true
    tcl_eq(bar.identify(5, height / 2), 'slider').should == true
  end
end
