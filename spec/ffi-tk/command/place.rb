# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Place do
  @button = Tk::Button.new('.')

  it 'places a widget' do
    Tk::Place.place(@button, y: 42, x: 24)
    Tk::Place.info(@button).should == {
      in: '.', x: 24, relx: 0.0, y: 42, rely: 0.0, width: 0, relwidth: 0.0,
      height: 0, relheight: 0.0, anchor: 'nw', bordermode: :inside
    }
  end

  it 'forgets the placement' do
    Tk::Place.forget(@button)
    Tk::Place.info(@button).should == {}
  end

  it 'configure(option) returns that option\'s coerced OptionDescription' do
    Tk::Place.place(@button, x: 24, y: 42, relx: 0.5)

    x = Tk::Place.configure(@button, :x)
    x.should.be.is_a? Tk::OptionDescription
    x.name.should == :x
    x.value.should == '24' # screen distance kept lossless as a :string

    Tk::Place.configure(@button, :relx).value.should == 0.5   # :float
    Tk::Place.configure(@button, :anchor).value.should == :nw # :symbol
  end

  it 'configure lists every place option as a coerced OptionDescription' do
    Tk::Place.place(@button, x: 24, y: 42)

    descriptions = Tk::Place.configure(@button)
    descriptions.should.be.is_a? Hash
    descriptions[:x].value.should == '24'
    descriptions[:anchor].value.should == :nw
  end

  # Widget includes Place, so the instance delegators forward self.
  describe 'Widget#place_* delegators forward self' do
    it 'places, reports info, lists slaves and forgets through the widget' do
      root = Tk.root
      b = Tk::Button.new(root, text: 'delegated')

      b.place_configure(x: 5, y: 6)
      info = b.place_info
      info[:x].should == 5
      info[:y].should == 6

      root.place_slaves.should.include b.tk_pathname

      b.place_forget
      root.place_slaves.should.not.include b.tk_pathname
    end
  end
end
