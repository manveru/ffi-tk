# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Pack do
  @button = Tk::Button.new('.')

  it 'packs a widget' do
    Tk::Pack.pack(@button)
    Tk::Pack.info(@button).should == {
      in: '.', anchor: 'center', expand: false, fill: :none, ipadx: 0, ipady: 0,
      padx: 0, pady: 0, side: :top
    }
  end

  it 'forgets the packing' do
    Tk::Pack.forget(@button)
    -> { Tk::Pack.info(@button) }.should.raise
  end

  it 'toggles geometry propagation and reports the current state' do
    f = Tk::Frame.new('.')
    Tk::Pack.propagate(f, false)
    Tk::Pack.propagate(f).should == 0
    Tk::Pack.propagate(f, true)
    Tk::Pack.propagate(f).should == 1
  end

  it 'reconfigures packing options via #pack_configure' do
    b = Tk::Button.new('.')
    b.pack
    b.pack_configure(padx: 7, side: :left)
    info = b.pack_info
    info[:padx].should == 7
    info[:side].should == :left
    b.pack_forget
  end

  it 'lists the packed slaves and toggles propagation via the delegators' do
    f = Tk::Frame.new('.')
    b = Tk::Button.new(f)
    b.pack

    f.pack_slaves.should == [b.tk_pathname]

    f.pack_propagate(false)
    f.pack_propagate.should == 0
    f.pack_propagate(true)
    f.pack_propagate.should == 1
  end
end
