# frozen_string_literal: true

require_relative '../../helper'

Tk.init

# Regression: the public Raise#raise delegator was clobbered by the
# module_function `raise(window, above)`, binding `above` to `window`.
# Raise.raise itself now lives as `def self.raise` and no longer collides.
describe Tk::Raise do
  @a = Tk::Frame.new('.')
 @a.pack
  @b = Tk::Frame.new('.')
 @b.pack

  it 'raises a window above all siblings (above omitted)' do
    should.not.raise { Tk::Raise.raise(@a) }
  end

  it 'raises a window above a specific sibling' do
    should.not.raise { Tk::Raise.raise(@a, @b) }
  end

  it 'is reachable through Widget#raise' do
    should.not.raise { @a.raise }
    should.not.raise { @a.raise(@b) }
  end
end
