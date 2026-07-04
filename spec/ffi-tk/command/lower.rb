# frozen_string_literal: true

require_relative '../../helper'

Tk.init

# Regression: Lower.lower used to be `def lower(below = None)` (wrong arity,
# referenced an undefined `window`), so both the module function and
# Widget#lower raised on every call.
describe Tk::Lower do
  @a = Tk::Frame.new('.')
 @a.pack
  @b = Tk::Frame.new('.')
 @b.pack

  it 'lowers a window below all siblings (below omitted)' do
    should.not.raise { Tk::Lower.lower(@a) }
  end

  it 'lowers a window below a specific sibling' do
    should.not.raise { Tk::Lower.lower(@a, @b) }
  end

  it 'is reachable through Widget#lower' do
    should.not.raise { @a.lower }
    should.not.raise { @a.lower(@b) }
  end
end
