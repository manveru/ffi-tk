# frozen_string_literal: true

require_relative '../../helper'

# Pure unit specs for the Option schema value object: name normalisation, alias
# resolution, the UnknownOptionType contract, composition via merge, and the
# deliberate absence of any ancestor/standard fallback. No interpreter needed.
describe Tk::Option::Schema do
  # A small stand-in schema: one canonical option, one type, one alias.
  def schema
    Tk::Option::Schema.new(types: { background: :color }, aliases: { bg: :background })
  end

  # --- normalisation -------------------------------------------------------

  it 'normalises names to dashless symbols, accepting string/symbol/dashed forms' do
    schema.type_for(:background).should == :color
    schema.type_for('background').should == :color
    schema.type_for(:'-background').should == :color
    schema.type_for('-background').should == :color
  end

  # --- alias resolution ----------------------------------------------------

  it 'type_for follows an alias to its canonical option type' do
    schema.type_for(:bg).should == :color
    schema.type_for('-bg').should == :color
  end

  it 'canonical maps an alias to its canonical option' do
    schema.canonical(:bg).should == :background
    schema.canonical('-bg').should == :background
  end

  it 'canonical returns the option itself when it is not an alias' do
    schema.canonical(:background).should == :background
    schema.canonical(:whatever).should == :whatever
  end

  # --- unknown options -----------------------------------------------------

  it 'type_for raises Tk::UnknownOptionType for an undeclared option' do
    -> { schema.type_for(:nonexistent) }.should.raise(Tk::UnknownOptionType)
  end

  it 'does NOT fall back to any standard/ancestor set for an unknown option' do
    widget_only = Tk::Option::Schema.new(types: { wrap: :boolean })
    # :background is a classic standard option, but this schema never declared
    # it, so lookup must raise rather than borrow it from anywhere.
    -> { widget_only.type_for(:background) }.should.raise(Tk::UnknownOptionType)
  end

  # --- names ---------------------------------------------------------------

  it 'names lists both canonical options and aliases' do
    schema.names.sort.should == %i[background bg]
  end

  # --- merge / composition -------------------------------------------------

  it 'merge composes the types and aliases of both schemas' do
    merged = schema.merge(Tk::Option::Schema.new(types: { wrap: :symbol }, aliases: { w: :wrap }))
    merged.type_for(:background).should == :color
    merged.type_for(:wrap).should == :symbol
    merged.type_for(:bg).should == :color
    merged.type_for(:w).should == :symbol
  end

  it 'merge lets the other schema win on a name collision' do
    base = Tk::Option::Schema.new(types: { wrap: :symbol })
    over = Tk::Option::Schema.new(types: { wrap: :boolean })
    base.merge(over).type_for(:wrap).should == :boolean
    over.merge(base).type_for(:wrap).should == :symbol
  end

  it 'merge returns a new schema without mutating the operands' do
    a = schema
    b = Tk::Option::Schema.new(types: { wrap: :symbol })
    a.merge(b)
    -> { a.type_for(:wrap) }.should.raise(Tk::UnknownOptionType)
    -> { b.type_for(:background) }.should.raise(Tk::UnknownOptionType)
  end

  it 'EMPTY is the neutral element for merge' do
    Tk::Option::Schema::EMPTY.merge(schema).should == schema
    schema.merge(Tk::Option::Schema::EMPTY).should == schema
  end

  # --- value object semantics ---------------------------------------------

  it 'is frozen, with frozen internal tables' do
    schema.should.be.frozen
    schema.types.should.be.frozen
    schema.aliases.should.be.frozen
  end

  it 'compares by value' do
    schema.should == Tk::Option::Schema.new(types: { background: :color }, aliases: { bg: :background })
    schema.should.not == Tk::Option::Schema.new(types: { background: :color })
  end
end
