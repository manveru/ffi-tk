# frozen_string_literal: true

require_relative '../../helper'

# End-to-end specs for the one type-directed coercer. Every one of the 12 Option
# types is exercised with a real value, with the empty-value rule, and with
# garbage where the type can reject it. Coercion reads raw Tcl strings, so this
# needs a live interpreter (Tk.boolean / split_list / :variable / :pathname).
describe Tk::Option::Coercer do
  def coerce(type, raw)
    Tk::Option::Coercer.coerce(type, raw)
  end

  # --- :string -------------------------------------------------------------

  it ':string returns the raw string, "" for empty' do
    coerce(:string, 'hello').should == 'hello'
    coerce(:string, '').should == ''
  end

  # --- :list ---------------------------------------------------------------

  it ':list splits a Tcl list into String elements, [] for empty' do
    coerce(:list, 'a b c').should == %w[a b c]
    coerce(:list, '{a b} c').should == ['a b', 'c']
    coerce(:list, '').should == []
  end

  it ':list keeps numeric-looking elements as strings (no shimmer typing)' do
    coerce(:list, '1 2 3').should == %w[1 2 3]
  end

  it ':list raises on an unbalanced (garbage) list' do
    -> { coerce(:list, '{') }.should.raise(RuntimeError)
  end

  # --- :integer ------------------------------------------------------------

  it ':integer parses an integer, nil for empty' do
    coerce(:integer, '42').should == 42
    coerce(:integer, '-7').should == -7
    coerce(:integer, '').should.be.nil
  end

  it ':integer raises on garbage' do
    -> { coerce(:integer, 'abc') }.should.raise(ArgumentError)
  end

  # --- :float --------------------------------------------------------------

  it ':float parses a float, nil for empty' do
    coerce(:float, '1.5').should == 1.5
    coerce(:float, '2').should == 2.0
    coerce(:float, '').should.be.nil
  end

  it ':float raises on garbage' do
    -> { coerce(:float, 'abc') }.should.raise(ArgumentError)
  end

  # --- :symbol -------------------------------------------------------------

  it ':symbol symbolizes the string, nil for empty' do
    coerce(:symbol, 'normal').should == :normal
    coerce(:symbol, '').should.be.nil
  end

  # --- :boolean ------------------------------------------------------------

  it ':boolean coerces Tcl truth words, nil for empty' do
    coerce(:boolean, '1').should == true
    coerce(:boolean, '0').should == false
    coerce(:boolean, 'yes').should == true
    coerce(:boolean, 'off').should == false
    coerce(:boolean, '').should.be.nil
  end

  # Tk.boolean is lenient: a non-boolean word does not raise, it reads as false.
  # Pinned so the behaviour is deliberate, not accidental. In practice Tk never
  # reports a non-boolean for a :boolean option.
  it ':boolean reads an unparseable word as false (Tk.boolean is lenient)' do
    coerce(:boolean, 'notabool').should == false
  end

  # --- :color / :font / :bitmap / :command --------------------------------

  it ':color returns the raw string, nil for empty' do
    coerce(:color, '#ff0000').should == '#ff0000'
    coerce(:color, 'red').should == 'red'
    coerce(:color, '').should.be.nil
  end

  it ':color does not validate: an arbitrary string passes through unchanged' do
    coerce(:color, 'definitely-not-a-color').should == 'definitely-not-a-color'
  end

  it ':font returns the raw string, nil for empty' do
    coerce(:font, 'TkDefaultFont').should == 'TkDefaultFont'
    coerce(:font, '').should.be.nil
  end

  it ':bitmap returns the raw string, nil for empty' do
    coerce(:bitmap, 'questhead').should == 'questhead'
    coerce(:bitmap, '').should.be.nil
  end

  it ':command returns the raw string, nil for empty' do
    coerce(:command, 'puts hi').should == 'puts hi'
    coerce(:command, '').should.be.nil
  end

  # --- :variable -----------------------------------------------------------

  it ':variable wraps the name in a Tk::Variable, nil for empty' do
    var = coerce(:variable, 'myvar')
    var.class.should == Tk::Variable
    var.name.should == 'myvar'
    coerce(:variable, '').should.be.nil
  end

  # --- :pathname -----------------------------------------------------------

  it ':pathname resolves a registered path to its widget' do
    frame = Tk::Frame.new
    coerce(:pathname, frame.tk_pathname).should.equal frame
  end

  it ':pathname is nil for an unregistered path and for empty' do
    coerce(:pathname, '.nope.not.registered').should.be.nil
    coerce(:pathname, '').should.be.nil
  end

  # --- unknown type --------------------------------------------------------

  it 'raises Tk::UnknownOptionType for a type outside the vocabulary' do
    -> { coerce(:bogus, 'x') }.should.raise(Tk::UnknownOptionType)
  end

  # --- empty-value rule, pinned exhaustively for all 12 types -------------

  it 'applies the empty-value rule to every type' do
    coerce(:string, '').should == ''
    coerce(:list, '').should == []

    %i[integer float symbol boolean color font bitmap command variable pathname].each do |type|
      coerce(type, '').should.be.nil
    end
  end
end
