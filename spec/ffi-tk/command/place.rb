require_relative '../../helper'

Tk.init

describe Tk::Place do
  @button = Tk::Button.new('.')

  it 'places a widget' do
    Tk::Place.place(@button, y: 42, x: 24)
    Tk::Place.info(@button).should == {
      in: ".", x: 24, relx: 0.0, y: 42, rely: 0.0, width: 0, relwidth: 0.0,
      height: 0, relheight: 0.0, anchor: "nw", bordermode: :inside
    }
  end

  it 'forgets the placement' do
    Tk::Place.forget(@button)
    Tk::Place.info(@button).should == {}
  end
end